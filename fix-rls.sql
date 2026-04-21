-- ============================================================
-- FIX: Elimina le policy vecchie e le ricrea correttamente
-- Incolla tutto nell'SQL Editor di Supabase e clicca Run
-- ============================================================

-- 1. Rimuovi le policy che causano la ricorsione
drop policy if exists "Owner full access"                on public.picnics;
drop policy if exists "Guests can view picnic"           on public.picnics;
drop policy if exists "Owner can manage guests"          on public.picnic_guests;
drop policy if exists "Guest sees own picnic members"    on public.picnic_guests;
drop policy if exists "Guest can update own status"      on public.picnic_guests;
drop policy if exists "Owner manages food"               on public.food_items;
drop policy if exists "Guest reads food"                 on public.food_items;
drop policy if exists "Owner manages schedule"           on public.schedule_items;
drop policy if exists "Guest reads schedule"             on public.schedule_items;

-- 2. Funzione helper (security definer = bypassa RLS, evita ricorsione)
create or replace function public.my_picnic_ids()
returns setof uuid
language sql
security definer
stable
set search_path = public
as $$
  select picnic_id from public.picnic_guests where user_id = auth.uid();
$$;

-- 3. Ricrea le policy usando la funzione helper

-- PICNICS
create policy "Owner full access" on public.picnics
  for all using (auth.uid() = owner_id);

create policy "Guests can view picnic" on public.picnics
  for select using (id in (select public.my_picnic_ids()));

-- PICNIC_GUESTS
create policy "Owner can manage guests" on public.picnic_guests
  for all using (
    picnic_id in (select id from public.picnics where owner_id = auth.uid())
  );

create policy "Guest reads members" on public.picnic_guests
  for select using (
    user_id = auth.uid()
    or picnic_id in (select public.my_picnic_ids())
  );

create policy "Guest updates own status" on public.picnic_guests
  for update using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- FOOD_ITEMS
create policy "Owner manages food" on public.food_items
  for all using (
    picnic_id in (select id from public.picnics where owner_id = auth.uid())
  );

create policy "Guest reads food" on public.food_items
  for select using (picnic_id in (select public.my_picnic_ids()));

-- SCHEDULE_ITEMS
create policy "Owner manages schedule" on public.schedule_items
  for all using (
    picnic_id in (select id from public.picnics where owner_id = auth.uid())
  );

create policy "Guest reads schedule" on public.schedule_items
  for select using (picnic_id in (select public.my_picnic_ids()));
