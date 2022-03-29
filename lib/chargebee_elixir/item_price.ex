defmodule ChargebeeElixir.ItemPrice do
  @moduledoc """
  an interface for interacting with Items
  """
  alias ChargebeeElixir.ItemPrice.Tier

  use ChargebeeElixir.Resource, "item_price"

  typed_embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:item_family_id, :string)
    field(:item_id, :string)
    field(:description, :string)
    field(:status, Ecto.Enum, values: [:active, :archived, :deleted])
    field(:external_name, :string)
    field(:pricing_model, Ecto.Enum, values: [:flat_fee, :per_unit, :tiered, :volume, :stairstep])
    field(:price, :integer)
    field(:price_in_decimal, :string)
    field(:period, :integer)
    field(:currency_code, :string)
    field(:trial_period, :integer)
    field(:trial_period_unit, Ecto.Enum, values: [:day, :month], optional: true)

    field(:trial_end_action, Ecto.Enum,
      values: [:side_default, :activate_subscription, :cancel_subscription],
      optional: true
    )

    field(:shipping_period, :integer)
    field(:shipping_period_unit, Ecto.Enum, values: [:day, :week, :month, :year], optional: true)
    field(:billing_cycles, :integer)
    field(:free_quantity, :integer)
    field(:free_quantity_in_decimal, :string)
    field(:resouce_version, :integer)
    field(:updated_at, :integer)
    field(:created_at, :integer)
    field(:archived_at, :integer)
    field(:invoice_notes, :string)
    field(:is_taxable, :boolean)
    field(:metadata, :map)
    field(:item_type, Ecto.Enum, values: [:plan, :addon, :charge], optional: true)
    field(:show_description_in_invoices, :boolean)
    field(:show_description_in_quotes, :boolean)
    embeds_many(:tiers, Tier)
    field(:tax_detail, :map)
    field(:accounting_detail, :map)
  end
end
