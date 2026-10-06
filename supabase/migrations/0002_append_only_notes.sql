create function immutable_note() returns trigger language plpgsql as $$ begin raise exception 'Notes are append-only'; end $$;
create trigger immutable_note before update or delete on notes for each row execute function immutable_note();
