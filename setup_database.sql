-- 1. Create the categories table
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    icon_name TEXT,
    image_url TEXT,
    icon_color_hex TEXT,
    bg_color_hex TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Modify the products table to use category_id instead of category text
-- We will drop the existing text column and add a foreign key
ALTER TABLE public.products 
DROP COLUMN IF EXISTS category;

ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS features JSONB;

-- 3. Insert default categories
INSERT INTO public.categories (id, name, icon_name, icon_color_hex, bg_color_hex)
VALUES 
    ('11111111-1111-1111-1111-111111111111', 'Solar Panels', 'solar_power_rounded', '#4CAF50', '#E8F5E9'),
    ('22222222-2222-2222-2222-222222222222', 'Batteries', 'battery_charging_full_rounded', '#2196F3', '#E3F2FD'),
    ('33333333-3333-3333-3333-333333333333', 'Inverters', 'power_rounded', '#FF9800', '#FFF3E0'),
    ('44444444-4444-4444-4444-444444444444', 'Wind Energy', 'wind_power_rounded', '#9C27B0', '#F3E5F5'),
    ('55555555-5555-5555-5555-555555555555', 'Accessories', 'cable_rounded', '#607D8B', '#ECEFF1'),
    ('66666666-6666-6666-6666-666666666666', 'EV Chargers', 'ev_station_rounded', '#F44336', '#FFEBEE');

-- 4. Re-insert sample products using the new category references
-- Clear old products first
DELETE FROM public.products;

INSERT INTO public.products (title, description, price, features, image_path, is_best_seller, category_id)
VALUES 
    ('EcoVolt 1KW Solar Panel', 'High efficiency monocrystalline solar panel.', 150.00, '["High efficiency", "Weather resistant"]', 'assets/images/ev3.png', true, '11111111-1111-1111-1111-111111111111'),
    ('Smart Solar Inverter 2KVA', 'Pure sine wave inverter for solar power.', 320.00, '["Pure sine wave", "Smart monitoring"]', 'assets/images/ev1.png', false, '33333333-3333-3333-3333-333333333333'),
    ('Lithium Ion Battery 100Ah', 'Deep cycle battery for energy storage.', 450.00, '["Long life", "Fast charging"]', 'assets/images/ev2.png', true, '22222222-2222-2222-2222-222222222222');
