insert into customers(code,name,email,last_contact) values
 ('KOWHAI','Kowhai College','transport@example.invalid',current_date-35),
 ('HARBOUR','Harbour Conference','events@example.invalid',current_date-18),
 ('HARBOUR2','Harbour Tours','tours@example.invalid',current_date-2) on conflict(code) do nothing;
insert into vehicles(code,name,seats,country,status,inspection_due,service_due,evidence) values
 ('BUS01','Kauri 49-seat',49,'NZ','available',current_date+100,current_date+12,'Demo CoF register'),
 ('BUS02','Rimu 22-seat',22,'NZ','available',current_date-2,current_date-5,'Demo expired CoF'),
 ('BUS03','Banksia 48-seat',48,'AU','workshop',current_date+100,current_date+20,'Demo workshop record') on conflict(code) do nothing;
insert into drivers(code,name,country,licence_due,passenger_due,fatigue_scheme,evidence) values
 ('ANA','Ana Roberts','NZ',current_date+300,current_date+90,'NZ standard','Demo register; verify licence class'),
 ('MIKE','Mike Wilson','NZ',current_date+300,current_date-1,'NZ standard','Demo expired endorsement'),
 ('JO','Jo Taylor','AU',current_date+300,current_date+50,'unverified','') on conflict(code) do nothing;
insert into contracts(code,name,customer_id,starts_on,ends_on,review_on) select 'SCH26','School athletics season',id,current_date-60,current_date+25,current_date-3 from customers where code='KOWHAI' on conflict(code) do nothing;
insert into bookings(code,name,customer_id,contract_id,status,currency,amount_cents,quote_due)
 select 'CH100','Athletics return charter',c.id,x.id,'confirmed','NZD',98000,null from customers c join contracts x on x.code='SCH26' where c.code='KOWHAI' on conflict(code) do nothing;
insert into bookings(code,name,customer_id,status,currency,amount_cents,quote_due)
 select 'CH101','Conference airport transfer',id,'confirmed','NZD',64000,null from customers where code='HARBOUR' on conflict(code) do nothing;
insert into bookings(code,name,customer_id,status,currency,amount_cents,quote_due)
 select 'Q102','Harbour weekend excursion',id,'quote','NZD',145000,current_date-4 from customers where code='HARBOUR2' on conflict(code) do nothing;
insert into bookings(code,name,customer_id,status,currency,amount_cents)
 select 'CH099','Completed museum visit',id,'completed','NZD',72000 from customers where code='KOWHAI' on conflict(code) do nothing;
insert into movements(code,name,booking_id,starts_at,ends_at,pickup,destination,passengers)
 select 'M100','Athletics outbound',id,current_date+interval '1 day 8 hours',current_date+interval '1 day 10 hours','Kowhai College','Regional athletics park',42 from bookings where code='CH100' on conflict(code) do nothing;
insert into movements(code,name,booking_id,starts_at,ends_at,pickup,destination,passengers)
 select 'M101','Athletics return',id,current_date+interval '1 day 15 hours',current_date+interval '1 day 17 hours','Regional athletics park','Kowhai College',42 from bookings where code='CH100' on conflict(code) do nothing;
insert into movements(code,name,booking_id,starts_at,ends_at,pickup,destination,passengers)
 select 'M102','Airport arrivals',id,current_date+interval '1 day 9 hours',current_date+interval '1 day 11 hours','Airport arrivals','Harbour Conference',30 from bookings where code='CH101' on conflict(code) do nothing;
insert into allocations(code,movement_id,vehicle_id,driver_id) select 'A100',m.id,v.id,d.id from movements m,vehicles v,drivers d
 where m.code='M100' and v.code='BUS01' and d.code='ANA' and not exists(select 1 from allocations where code='A100');
insert into invoices(code,name,booking_id,issued_on,due_on,amount_cents,paid_cents)
 select 'INV099','Museum charter balance',id,current_date-30,current_date-16,72000,20000 from bookings where code='CH099' on conflict(code) do nothing;
insert into work_blocks(code,name,driver_id,starts_at,ends_at,kind,cumulative_day,evidence)
 select 'W001','Recorded work, break missing',id,current_date-1+interval '6 hours',current_date-1+interval '12 hours','work',current_date-1,'Fictional imported work record' from drivers where code='ANA' and not exists(select 1 from work_blocks where code='W001');
