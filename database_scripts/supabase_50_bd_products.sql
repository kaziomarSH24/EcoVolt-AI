-- ==============================================================================
-- 50 REALISTIC POWER SOLUTION PRODUCTS FOR BANGLADESH MARKET
-- Categories: Solar, Batteries, Inverters (IPS), Generators
-- ==============================================================================

-- ==============================================================================
-- 1. SOLAR PANELS (15 Products)
-- ==============================================================================
INSERT INTO products (title, price, image_path, is_best_seller, description, features) VALUES
('Longi 550W Mono PERC Half-Cut Solar Panel', 22500, 'assets/images/solar_placeholder.png', true, 'High efficiency Tier 1 solar panel from Longi, perfect for home and commercial solar setups.', ARRAY['550W', 'Mono PERC', 'Half-Cut Cell', 'Tier 1']),
('Jinko Solar 545W Tiger Pro Bifacial', 23000, 'assets/images/solar_placeholder.png', false, 'Bifacial panel that generates power from both sides, yielding up to 25% more energy.', ARRAY['545W', 'Bifacial', 'Tier 1']),
('Trina Solar 500W Vertex Monocrystalline', 20500, 'assets/images/solar_placeholder.png', true, 'Reliable 500W panel for residential installations.', ARRAY['500W', 'Monocrystalline', '21% Efficiency']),
('Canadian Solar 450W KuMax Poly', 17000, 'assets/images/solar_placeholder.png', false, 'Highly durable polycrystalline panel for cost-effective setups.', ARRAY['450W', 'Polycrystalline', 'Cost-effective']),
('EcoVolt 300W Monocrystalline Panel', 11500, 'assets/images/solar_placeholder.png', true, 'Standard 300W panel for small IPS and solar setups.', ARRAY['300W', 'Monocrystalline', 'Local Warranty']),
('Rahimafrooz 250W Polycrystalline Solar Panel', 9500, 'assets/images/solar_placeholder.png', false, 'Trusted local brand solar panel for rural electrification.', ARRAY['250W', 'Polycrystalline', 'Durable']),
('Navana 150W Solar Panel', 6000, 'assets/images/solar_placeholder.png', false, 'Small 150W panel for basic lighting and fan loads.', ARRAY['150W', '12V System Compatible']),
('JA Solar 550W DeepBlue 3.0 Mono', 22000, 'assets/images/solar_placeholder.png', false, 'Advanced Mono PERC technology for superior low-light performance.', ARRAY['550W', 'Mono PERC']),
('Suntech 330W Polycrystalline Panel', 13500, 'assets/images/solar_placeholder.png', false, 'Medium capacity panel for residential rooftops.', ARRAY['330W', 'Polycrystalline']),
('Walton 100W Solar Panel', 4200, 'assets/images/solar_placeholder.png', true, 'Best for small DC systems and student projects.', ARRAY['100W', '12V', 'Compact']),
('Longi 400W All Black Mono Panel', 18000, 'assets/images/solar_placeholder.png', false, 'Premium all-black aesthetic solar panel.', ARRAY['400W', 'All Black', 'Aesthetic']),
('Jinko 600W Tiger Neo N-Type', 26000, 'assets/images/solar_placeholder.png', false, 'Ultra high power N-Type panel for industrial use.', ARRAY['600W', 'N-Type', 'Ultra High Efficiency']),
('EcoVolt 50W Mini Solar Panel', 2500, 'assets/images/solar_placeholder.png', false, 'Miniature solar panel for charging electronics or small batteries.', ARRAY['50W', 'Portable']),
('Trina 400W Vertex S Mono', 17500, 'assets/images/solar_placeholder.png', false, 'Compact high power panel for residential roofs.', ARRAY['400W', 'Compact Design']),
('Canadian Solar 600W BiHiKu', 25500, 'assets/images/solar_placeholder.png', false, 'Massive 600W bifacial panel for solar parks.', ARRAY['600W', 'Bifacial', 'Industrial']);

-- ==============================================================================
-- 2. BATTERIES (15 Products)
-- ==============================================================================
INSERT INTO products (title, price, image_path, is_best_seller, description, features) VALUES
('Rahimafrooz IPB 120Ah Tall Tubular Battery', 18500, 'assets/images/battery_placeholder.png', true, 'The most popular tubular battery in Bangladesh for IPS. Long backup time.', ARRAY['12V 120Ah', 'Tubular Plate', 'Deep Cycle']),
('Luminous RedCharge RC 18000 150Ah Battery', 22000, 'assets/images/battery_placeholder.png', true, 'Heavy duty tubular battery designed to withstand long power cuts.', ARRAY['12V 150Ah', 'Fast Charging', 'Rugged']),
('Navana 200Ah Deep Cycle Tubular Battery', 26500, 'assets/images/battery_placeholder.png', false, 'Massive capacity battery for 2KW+ systems.', ARRAY['12V 200Ah', 'Deep Cycle', 'Heavy Duty']),
('Volta 100Ah IPS Battery', 14500, 'assets/images/battery_placeholder.png', false, 'Budget friendly flat plate battery for light usage.', ARRAY['12V 100Ah', 'Flat Plate', 'Budget']),
('Hamko HPD 130Ah Tubular Battery', 19000, 'assets/images/battery_placeholder.png', false, 'Premium quality tubular battery by Hamko.', ARRAY['12V 130Ah', 'Tubular']),
('Rimso 150Ah Solar Battery', 21500, 'assets/images/battery_placeholder.png', false, 'Specially designed for solar charging with low maintenance.', ARRAY['12V 150Ah', 'Solar Optimized']),
('EcoVolt 48V 100Ah Lithium Ion (LiFePO4) Battery', 125000, 'assets/images/battery_placeholder.png', true, 'Modern Lithium Iron Phosphate battery. 10 years life span, zero maintenance.', ARRAY['48V 100Ah (4.8kWh)', 'LiFePO4', '6000 Cycles', 'BMS Included']),
('Walton 65Ah IPS Battery', 9500, 'assets/images/battery_placeholder.png', false, 'Small capacity battery for a single fan and light.', ARRAY['12V 65Ah', 'Compact']),
('Luminous Inverlast 200Ah Tubular', 28000, 'assets/images/battery_placeholder.png', false, 'Ultimate backup battery from Luminous.', ARRAY['12V 200Ah', 'Super Heavy Duty']),
('Rahimafrooz Globatt 100Ah Maintenance Free', 16000, 'assets/images/battery_placeholder.png', false, 'Sealed maintenance free (SMF) battery. No water top-up required.', ARRAY['12V 100Ah', 'SMF', 'No Water Needed']),
('Long WP12-12 12V 12Ah SLA Battery', 2200, 'assets/images/battery_placeholder.png', false, 'Small dry cell battery for UPS and alarm systems.', ARRAY['12V 12Ah', 'SLA / Dry Cell']),
('CSB 12V 7Ah UPS Battery', 1500, 'assets/images/battery_placeholder.png', true, 'Standard replacement battery for desktop UPS.', ARRAY['12V 7.2Ah', 'UPS Battery']),
('EcoVolt 24V 200Ah Lithium Ion Wall Mount', 145000, 'assets/images/battery_placeholder.png', false, 'Sleek wall mounted lithium battery for modern homes.', ARRAY['24V 200Ah (4.8kWh)', 'Wall Mount', 'LCD Display']),
('Pylontech US2000C 48V 50Ah LiFePO4', 85000, 'assets/images/battery_placeholder.png', false, 'Server rack style lithium battery for hybrid inverters.', ARRAY['48V 50Ah', 'Modular', 'LiFePO4']),
('Hamko 220Ah Jumbo Tubular Battery', 30000, 'assets/images/battery_placeholder.png', false, 'The largest capacity 12V tubular battery for extreme load shedding.', ARRAY['12V 220Ah', 'Jumbo Tubular']);


-- ==============================================================================
-- 3. IPS & INVERTERS (10 Products)
-- ==============================================================================
INSERT INTO products (title, price, image_path, is_best_seller, description, features) VALUES
('Luminous Eco Watt Neo 700 Square Wave IPS', 10500, 'assets/images/ips_placeholder.png', true, 'India''s most trusted square wave IPS. Supports 1 battery. Perfect for 3 fans and 3 lights.', ARRAY['600VA (504W)', 'Square Wave', '12V System']),
('Luminous Zelio+ 1100 Pure Sine Wave IPS', 14500, 'assets/images/ips_placeholder.png', true, 'Intelligent UPS with LED display showing backup time. Safe for TVs and computers.', ARRAY['900VA (756W)', 'Pure Sine Wave', 'LED Display']),
('Microtek Super Power 900 IPS', 11000, 'assets/images/ips_placeholder.png', false, 'Rugged and reliable IPS for harsh power conditions.', ARRAY['800VA', 'Square Wave']),
('Rahimafrooz 1000VA Pure Sine Wave IPS', 15500, 'assets/images/ips_placeholder.png', false, 'Local assembled premium IPS with pure sine wave output.', ARRAY['1000VA', 'Pure Sine Wave']),
('EcoVolt 2KVA Pure Sine Wave IPS', 24000, 'assets/images/ips_placeholder.png', true, 'Heavy duty IPS supporting 2 batteries. Can run a 1HP water pump.', ARRAY['2KVA (1600W)', '24V System', 'Pure Sine Wave']),
('Growatt 3KW SPF 3000TL HVM Solar Hybrid Inverter', 38000, 'assets/images/ips_placeholder.png', true, 'Off-grid solar inverter with built-in MPPT charge controller.', ARRAY['3KW Output', 'Built-in 80A MPPT', '24V System', 'Wifi Ready']),
('Deye 5KW Hybrid Inverter (Grid-Tied + Off-Grid)', 115000, 'assets/images/ips_placeholder.png', false, 'Premium hybrid inverter. Can export power to the grid and run without batteries.', ARRAY['5KW', 'Hybrid', '48V System', 'Dual MPPT']),
('Luminous Solar Hybrid 1100', 16500, 'assets/images/ips_placeholder.png', false, 'IPS with built-in solar charge controller. Connect panels directly.', ARRAY['850VA', 'PWM Solar Controller', '12V System']),
('Walton 600VA Smart IPS', 9000, 'assets/images/ips_placeholder.png', false, 'Affordable smart IPS from Walton.', ARRAY['600VA', 'Smart Protection']),
('SMA Sunny Boy 3.0 Grid-Tied Inverter', 85000, 'assets/images/ips_placeholder.png', false, 'German engineered grid-tied inverter for net metering systems.', ARRAY['3KW', 'Grid-Tied Only', 'No Battery Needed']);


-- ==============================================================================
-- 4. GENERATORS (10 Products)
-- ==============================================================================
INSERT INTO products (title, price, image_path, is_best_seller, description, features) VALUES
('Honda EP 1000 Portable Petrol Generator', 38000, 'assets/images/gen_placeholder.png', true, 'Reliable 750W petrol generator. Very low noise, easy start.', ARRAY['750W Rated', 'Petrol', 'Recoil Start']),
('Honda EU22i Inverter Generator', 125000, 'assets/images/gen_placeholder.png', false, 'Ultra quiet inverter generator. Safe for highly sensitive medical and IT equipment.', ARRAY['2.2KW', 'Inverter Tech', 'Super Silent']),
('Walton 2KW Portable Petrol Generator', 42000, 'assets/images/gen_placeholder.png', true, 'Affordable local brand generator capable of running a 1-ton AC.', ARRAY['2KW', 'Petrol', 'Electric Start']),
('Yamaha EF2600 2.5KW Petrol Generator', 65000, 'assets/images/gen_placeholder.png', false, 'Heavy duty Japanese generator for continuous operation.', ARRAY['2.5KW', 'Petrol', '4-Stroke Engine']),
('Kamal 5KW Diesel Generator', 85000, 'assets/images/gen_placeholder.png', false, 'Open type diesel generator for shops and small factories.', ARRAY['5KW', 'Diesel', 'Open Type']),
('Kipor 6KW Silent Diesel Generator', 145000, 'assets/images/gen_placeholder.png', true, 'Silent canopy diesel generator. Perfect for homes and offices needing heavy load backup.', ARRAY['6KW', 'Diesel', 'Silent Canopy', 'Electric Start']),
('Honda EB 3000 Petrol Generator', 72000, 'assets/images/gen_placeholder.png', false, '3KW reliable power for commercial spaces.', ARRAY['3KW', 'Petrol', 'Durable Frame']),
('Astra Korea 2.5KW Gas/Petrol Dual Fuel', 48000, 'assets/images/gen_placeholder.png', false, 'Can run on both Petrol and LPG gas cylinders to save fuel costs.', ARRAY['2.5KW', 'Dual Fuel (LPG/Petrol)']),
('Perkins 10KW Industrial Diesel Generator', 450000, 'assets/images/gen_placeholder.png', false, 'Industrial grade generator for large buildings, hospitals, or factories.', ARRAY['10KW', 'Diesel', 'Water Cooled', 'ATS Compatible']),
('Walton 1.2KW Portable Generator', 28000, 'assets/images/gen_placeholder.png', false, 'Small, budget-friendly generator for basic lighting and fan loads during load shedding.', ARRAY['1.2KW', 'Petrol', 'Compact']);
