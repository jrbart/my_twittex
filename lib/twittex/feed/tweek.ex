defmodule Twittex.Feed.Tweek do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweeks" do
    field :content, :string
    belongs_to :user, Twittex.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tweek, attrs) do
    tweek
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> validate_length(:content, max: 25)
  end
end
