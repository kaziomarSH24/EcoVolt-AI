-- Run this script in the Supabase SQL Editor to insert some dummy solar products

-- Insert Solar Panels
INSERT INTO products (title, price, image_path, is_best_seller, description, features) VALUES
('EcoVolt Pro 500W Monocrystalline Solar Panel', 18500, 'assets/images/ev3.png', true, 'High efficiency 500W solar panel perfect for home usage.', '["500W Output", "Monocrystalline", "25 Years Warranty", "High Efficiency 21%"]'::jsonb),
('EcoVolt Lite 300W Polycrystalline Panel', 11000, 'assets/images/ev1.png', false, 'Cost-effective 300W panel for small setups.', '["300W Output", "Polycrystalline", "10 Years Warranty", "Durable Frame"]'::jsonb),
('SunPower Max 550W Half-Cut Panel', 21000, 'assets/images/ev2.png', true, 'Premium 550W half-cut cell technology for maximum power.', '["550W Output", "Half-Cut Cells", "Anti-reflective coating", "25 Years Warranty"]'::jsonb);

-- Insert Inverters
INSERT INTO products (title, price, image_path, is_best_seller, description, features) VALUES
('EcoVolt Hybrid 3KW Inverter', 35000, 'assets/images/ev2.png', true, 'Smart hybrid inverter capable of handling up to 3KW load.', '["3KW Capacity", "Hybrid (Grid-tied & Off-grid)", "Built-in MPPT", "Wifi Monitoring"]'::jsonb),
('EcoVolt Smart 5KW Inverter', 55000, 'assets/images/ev1.png', false, 'Heavy duty 5KW inverter for large homes and small businesses.', '["5KW Capacity", "Dual MPPT", "Pure Sine Wave", "App Controlled"]'::jsonb);

-- Insert Batteries
INSERT INTO products (title, price, image_path, is_best_seller, description, features) VALUES
('EcoVolt PowerWall 48V 100Ah Lithium Battery', 120000, 'assets/images/ev3.png', true, 'Long-lasting lithium iron phosphate (LiFePO4) battery.', '["48V 100Ah (4.8KWh)", "LiFePO4 Chemistry", "6000 Cycles", "Built-in BMS"]'::jsonb),
('EcoVolt Tubular Gel 12V 200Ah', 22000, 'assets/images/ev2.png', false, 'Reliable deep cycle tubular battery for solar setups.', '["12V 200Ah", "Tubular Gel", "Deep Cycle", "Low Maintenance"]'::jsonb);
