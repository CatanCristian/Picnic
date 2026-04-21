-- ============================================================
-- PICNIC ORGANIZER — Supabase Setup
-- Incolla tutto questo nell'SQL Editor di Supabase
-- ============================================================

-- 1. TABLES ---------------------------------------------------

create table public.picnics (
  id          uuid primary key default gen_random_uuid(),
  owner_id    uuid not null references auth.users(id) on delete cascade,
  name        text not null,
  date_label  text,
  date_iso    date,
  location    text,
  created_at  timestamptz default now()
);

create table public.picnic_guests (
  id           uuid primary key default gen_random_uuid(),
  picnic_id    uuid not null references public.picnics(id) on delete cascade,
  email        text not null,
  name         text,
  status       text not null default 'pending',   -- pending | yes | no
  user_id      uuid references auth.users(id),
  invite_token uuid not null default gen_random_uuid(),
  created_at   timestamptz default now(),
  unique(picnic_id, email)
);

create table public.food_items (
  id         uuid primary key default gen_random_uuid(),
  picnic_id  uuid not null references public.picnics(id) on delete cascade,
  name       text not null,
  done       boolean default false,
  cat        text default 'cibo',
  created_at timestamptz default now()
);

create table public.schedule_items (
  id         uuid primary key default gen_random_uuid(),
  picnic_id  uuid not null references public.picnics(id) on delete cascade,
  time_label text,
  title      text not null,
  note       text,
  done       boolean default false,
  sort_order int default 0,
  created_at timestamptz default now()
);

-- 2. ROW LEVEL SECURITY ----------------------------------------

alter table public.picnics        enable row level security;
alter table public.picnic_guests  enable row level security;
alter table public.food_items     enable row level security;
alter table public.schedule_items enable row level security;

-- PICNICS
create policy "Owner full access" on public.picnics
  for all using (auth.uid() = owner_id);

create policy "Guests can view picnic" on public.picnics
  for select using (
    id in (select picnic_id from public.picnic_guests where user_id = auth.uid())
  );

-- PICNIC_GUESTS
create policy "Owner can manage guests" on public.picnic_guests
  for all using (
    picnic_id in (select id from public.picnics where owner_id = auth.uid())
  );

create policy "Guest sees own picnic members" on public.picnic_guests
  for select using (
    picnic_id in (select picnic_id from public.picnic_guests where user_id = auth.uid())
  );

create policy "Guest can update own status" on public.picnic_guests
  for update using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- FOOD_ITEMS
create policy "Owner manages food" on public.food_items
  for all using (
    picnic_id in (select id from public.picnics where owner_id = auth.uid())
  );

create policy "Guest reads food" on public.food_items
  for select using (
    picnic_id in (select picnic_id from public.picnic_guests where user_id = auth.uid())
  );

-- SCHEDULE_ITEMS
create policy "Owner manages schedule" on public.schedule_items
  for all using (
    picnic_id in (select id from public.picnics where owner_id = auth.uid())
  );

create policy "Guest reads schedule" on public.schedule_items
  for select using (
    picnic_id in (select picnic_id from public.picnic_guests where user_id = auth.uid())
  );

-- 3. FUNCTION: accept_invite -----------------------------------
-- Usa SECURITY DEFINER per bypassare RLS durante il claim del token

create or replace function public.accept_invite(p_token uuid, p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.picnic_guests
  set user_id = p_user_id
  where invite_token = p_token
    and (user_id is null or user_id = p_user_id);
end;
$$;
