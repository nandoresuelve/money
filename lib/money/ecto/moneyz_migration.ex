defmodule Money.Ecto.MoneyzMigration do
  defmacro __using__(_) do
    quote do
      use Ecto.Migration

      def up do
        execute "
        DO $$
          BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'moneyz') THEN
              DROP DOMAIN IF EXISTS currency_loose_type;
              CREATE DOMAIN currency_loose_type AS TEXT CHECK ( VALUE ~ '^[A-Z]{2,3}$' );
              CREATE TYPE moneyz AS (
                amount NUMERIC(19,0),
                currency currency_loose_type
              );
          END IF;
        END$$;"
      end

      def down do
        execute "
        DROP TYPE moneyz;
        DROP DOMAIN IF EXISTS currency_loose_type;
        "
      end
    end
  end
end
