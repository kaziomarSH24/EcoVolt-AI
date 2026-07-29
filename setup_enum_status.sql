-- 1. First, we need to drop the existing CHECK constraint that was created on the status column.
-- We use an anonymous block to dynamically find and drop it.
DO $$
DECLARE constraint_name TEXT;
BEGIN
  SELECT conname INTO constraint_name
  FROM pg_constraint
  WHERE conrelid = 'public.orders'::regclass
  AND pg_get_constraintdef(oid) LIKE '%status%';

  IF constraint_name IS NOT NULL THEN
    EXECUTE 'ALTER TABLE public.orders DROP CONSTRAINT ' || constraint_name;
  END IF;
END $$;

-- 2. Create the enum type (Added 'paid' to match your Dart code logic)
CREATE TYPE order_status AS ENUM ('pending', 'paid', 'processing', 'shipped', 'delivered', 'cancelled');

-- 3. Remove default value
ALTER TABLE public.orders ALTER COLUMN status DROP DEFAULT;

-- 4. Cast the column to the new ENUM type
ALTER TABLE public.orders 
  ALTER COLUMN status TYPE order_status 
  USING status::text::order_status;

-- 5. Set default back
ALTER TABLE public.orders ALTER COLUMN status SET DEFAULT 'pending'::order_status;
