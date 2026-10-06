create function stamp_updated() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end $$;
create table customers (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, email text, phone text,
 last_contact date, notes text not null default '', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table vehicles (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, seats integer not null check(seats>0),
 country text not null check(country in ('NZ','AU')), status text not null default 'available' check(status in ('available','workshop','retired')),
 inspection_due date, service_due date, evidence text not null default '', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table drivers (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, country text not null check(country in ('NZ','AU')),
 licence_due date, passenger_due date, fatigue_scheme text not null default 'unverified', evidence text not null default '',
 active boolean not null default true, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table contracts (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, customer_id uuid not null references customers,
 starts_on date not null, ends_on date not null, review_on date not null, notes text not null default '',
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), check(ends_on>=starts_on)
);
create table bookings (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, customer_id uuid not null references customers,
 contract_id uuid references contracts, status text not null default 'quote' check(status in ('quote','confirmed','completed','cancelled')),
 currency text not null check(currency in ('NZD','AUD')), amount_cents integer not null check(amount_cents>=0), quote_due date,
 notes text not null default '', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table movements (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, booking_id uuid not null references bookings,
 starts_at timestamptz not null, ends_at timestamptz not null, pickup text not null, destination text not null,
 passengers integer not null check(passengers>0), notes text not null default '',
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), check(ends_at>starts_at)
);
create table allocations (
 id uuid primary key default gen_random_uuid(), code text not null unique, movement_id uuid not null unique references movements,
 vehicle_id uuid not null references vehicles, driver_id uuid not null references drivers,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table invoices (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, booking_id uuid not null unique references bookings,
 issued_on date not null, due_on date not null, amount_cents integer not null check(amount_cents>=0),
 paid_cents integer not null default 0 check(paid_cents>=0 and paid_cents<=amount_cents),
 notes text not null default '', created_at timestamptz not null default now(), updated_at timestamptz not null default now(), check(due_on>=issued_on)
);
create table work_blocks (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, driver_id uuid not null references drivers,
 starts_at timestamptz not null, ends_at timestamptz not null, kind text not null check(kind in ('work','rest')),
 cumulative_day date not null, evidence text not null default '',
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), check(ends_at>starts_at)
);
create table notes (
 id uuid primary key default gen_random_uuid(), customer_id uuid not null references customers, happened_on date not null,
 author text not null, body text not null check(length(trim(body))>0), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create function allocation_guard() returns trigger language plpgsql as $$
declare m movements; v vehicles; d drivers; s text;
begin
 -- Serialise allocation writers, then re-read the schedule within the transaction.
 perform pg_advisory_xact_lock(7206501);
 select * into m from movements where id=new.movement_id;
 select status into s from bookings where id=m.booking_id;
 if s<>'confirmed' then raise exception 'Only confirmed bookings can be allocated'; end if;
 select * into v from vehicles where id=new.vehicle_id;
 select * into d from drivers where id=new.driver_id;
 if v.status<>'available' or not d.active then raise exception 'Vehicle or driver unavailable'; end if;
 if v.country<>d.country then raise exception 'Driver and vehicle country must match'; end if;
 if v.seats<m.passengers then raise exception 'Insufficient passenger seats'; end if;
 if v.inspection_due is null or v.inspection_due<(m.ends_at at time zone 'UTC')::date then raise exception 'Vehicle inspection evidence missing or expired for journey'; end if;
 if d.licence_due is null or d.passenger_due is null or least(d.licence_due,d.passenger_due)<(m.ends_at at time zone 'UTC')::date then raise exception 'Driver licence or passenger authority missing or expired for journey'; end if;
 if exists(select 1 from allocations a join movements x on x.id=a.movement_id join bookings b on b.id=x.booking_id
 where a.id<>new.id and b.status='confirmed' and (a.driver_id=new.driver_id or a.vehicle_id=new.vehicle_id)
 and x.starts_at<m.ends_at and x.ends_at>m.starts_at) then raise exception 'Driver or vehicle overlaps another movement'; end if;
 return new;
end $$;
create trigger allocation_guard before insert or update on allocations for each row execute function allocation_guard();
create function movement_guard() returns trigger language plpgsql as $$ begin
 perform pg_advisory_xact_lock(7206501);
 if exists(select 1 from allocations where movement_id=old.id) and
 (new.starts_at,new.ends_at,new.passengers,new.booking_id) is distinct from (old.starts_at,old.ends_at,old.passengers,old.booking_id)
 then raise exception 'Unallocate movement before changing time, passengers or booking'; end if;
 return new; end $$;
create trigger movement_guard before update on movements for each row execute function movement_guard();
create function booking_guard() returns trigger language plpgsql as $$ begin
 perform pg_advisory_xact_lock(7206501);
 if new.status<>old.status and exists(select 1 from allocations a join movements m on m.id=a.movement_id where m.booking_id=old.id)
 then raise exception 'Unallocate movements before changing booking status'; end if;
 return new; end $$;
create trigger booking_guard before update on bookings for each row execute function booking_guard();
create function work_guard() returns trigger language plpgsql as $$ begin
 perform pg_advisory_xact_lock(7206502);
 if exists(select 1 from work_blocks w where w.id<>new.id and w.driver_id=new.driver_id and w.starts_at<new.ends_at and w.ends_at>new.starts_at)
 then raise exception 'Work or rest block overlaps'; end if; return new; end $$;
create trigger work_guard before insert or update on work_blocks for each row execute function work_guard();
create view dispatch_diary as select m.id,m.code,b.code booking,c.name customer,m.name,m.starts_at,m.ends_at,m.pickup,m.destination,m.passengers,
 b.status,b.currency,v.code vehicle,v.seats,d.name driver,a.id allocation_id,
 case when a.id is null then 'UNALLOCATED' when v.status<>'available' or not d.active then 'UNAVAILABLE'
 when v.inspection_due is null or v.inspection_due<(m.ends_at at time zone 'UTC')::date then 'CHECK VEHICLE'
 when d.licence_due is null or d.passenger_due is null or least(d.licence_due,d.passenger_due)<(m.ends_at at time zone 'UTC')::date then 'CHECK DRIVER'
 when v.seats<m.passengers then 'CHECK SEATS' else 'ALLOCATED: verify duty and route' end readiness
 from movements m join bookings b on b.id=m.booking_id join customers c on c.id=b.customer_id
 left join allocations a on a.movement_id=m.id left join vehicles v on v.id=a.vehicle_id left join drivers d on d.id=a.driver_id;
create view debtors as select i.id,i.code,c.name customer,b.code booking,b.currency,i.due_on,i.amount_cents,i.paid_cents,
 i.amount_cents-i.paid_cents balance_cents,current_date-i.due_on days_overdue
 from invoices i join bookings b on b.id=i.booking_id join customers c on c.id=b.customer_id where i.amount_cents>i.paid_cents;
create view quote_followups as select b.id,b.code,b.name,c.name customer,b.currency,b.amount_cents,b.quote_due,c.last_contact,
 current_date-b.quote_due days_overdue from bookings b join customers c on c.id=b.customer_id where b.status='quote';
create view contract_review as select x.id,x.code,x.name,c.name customer,x.ends_on,x.review_on,
 (select count(*) from bookings b where b.contract_id=x.id and b.status='confirmed') confirmed_bookings
 from contracts x join customers c on c.id=x.customer_id;
create view duty_totals as select w.driver_id,d.name driver,d.country,d.fatigue_scheme,w.cumulative_day,
 round(sum(case when w.kind='work' then extract(epoch from (w.ends_at-w.starts_at))/60 else 0 end)) work_minutes,
 min(w.starts_at) first_record,max(w.ends_at) last_record,
 bool_and(w.evidence<>'') evidence_recorded
 from work_blocks w join drivers d on d.id=w.driver_id group by w.driver_id,d.name,d.country,d.fatigue_scheme,w.cumulative_day;

create trigger updated before update on customers for each row execute function stamp_updated();
alter table customers enable row level security;

create trigger updated before update on vehicles for each row execute function stamp_updated();
alter table vehicles enable row level security;

create trigger updated before update on drivers for each row execute function stamp_updated();
alter table drivers enable row level security;

create trigger updated before update on contracts for each row execute function stamp_updated();
alter table contracts enable row level security;

create trigger updated before update on bookings for each row execute function stamp_updated();
alter table bookings enable row level security;

create trigger updated before update on movements for each row execute function stamp_updated();
alter table movements enable row level security;

create trigger updated before update on allocations for each row execute function stamp_updated();
alter table allocations enable row level security;

create trigger updated before update on invoices for each row execute function stamp_updated();
alter table invoices enable row level security;

create trigger updated before update on work_blocks for each row execute function stamp_updated();
alter table work_blocks enable row level security;

create trigger updated before update on notes for each row execute function stamp_updated();
alter table notes enable row level security;

