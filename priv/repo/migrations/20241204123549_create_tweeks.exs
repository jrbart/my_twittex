defmodule Twittex.Repo.Migrations.CreateTweeks do
  use Ecto.Migration

  def change do
    create table(:tweeks) do
      add :content, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tweeks, [:user_id, :id])
  end
end
