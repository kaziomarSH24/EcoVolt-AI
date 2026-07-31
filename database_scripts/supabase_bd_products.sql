-- বাংলাদেশের বাস্তব প্রেক্ষাপট অনুযায়ী কিছু প্রোডাক্ট (IPS, Battery, Generator, Solar)
-- আপনার Supabase-এর SQL Editor-এ গিয়ে এই কোডটুকু Run করুন:

INSERT INTO products (title, price, image_path, is_best_seller, description, features) VALUES
('Luminous Eco Watt Neo 700 Square Wave IPS', 10500, 'assets/images/ev1.png', true, 'Reliable IPS for small homes in Bangladesh. Perfect for 3 fans and 3 lights.', '["600VA Capacity", "Supports 1 Battery", "Square Wave"]'::jsonb),

('Rahimafrooz IPB 120Ah Tubular Battery', 18500, 'assets/images/ev2.png', true, 'Heavy duty tall tubular battery for long backup during load shedding.', '["120Ah Capacity", "Tubular Plate", "Long Life"]'::jsonb),

('EcoVolt 1000VA Pure Sine Wave IPS', 15000, 'assets/images/ev1.png', false, 'Pure sine wave IPS for sensitive electronics like computers and TVs.', '["1000VA Capacity", "Pure Sine Wave", "Fast Charging"]'::jsonb),

('Luminous RedCharge 150Ah Tubular Battery', 21000, 'assets/images/ev2.png', true, 'Popular tubular battery for medium sized homes. Great pairing with Luminous IPS.', '["150Ah Capacity", "Fast Charge Acceptance", "Rugged Design"]'::jsonb),

('Honda EP 1000 Portable Generator', 35000, 'assets/images/ev3.png', false, 'Reliable petrol generator for small shops and backup power.', '["750W Rated Output", "Petrol Engine", "Portable"]'::jsonb),

('Walton 2KW Portable Petrol Generator', 42000, 'assets/images/ev3.png', false, 'Cost-effective local brand generator for heavy load shedding.', '["2KW Output", "Low Noise", "Easy Start"]'::jsonb),

('EcoVolt 300W Monocrystalline Solar Panel', 12000, 'assets/images/ev3.png', false, 'High efficiency solar panel for home systems.', '["300W Output", "Monocrystalline", "25 Years Warranty"]'::jsonb),

('Navana 200Ah Deep Cycle Battery', 26000, 'assets/images/ev2.png', false, 'High capacity deep cycle battery for heavy load and long backup.', '["200Ah Capacity", "Deep Cycle", "Low Maintenance"]'::jsonb);
