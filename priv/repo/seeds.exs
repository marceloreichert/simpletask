# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Simpletask.Repo.insert!(%Simpletask.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Simpletask.Repo

unit_type =
  Repo.insert!(%Simpletask.UnitTypes.UnitType{
    name: "Clínica Médica"
  })

unit =
  Repo.insert!(%Simpletask.Units.Unit{
    name: "Clínica Amendoim Quasqualho",
    unit_type_id: unit_type.id
  })

unit2 =
  Repo.insert!(%Simpletask.Units.Unit{
    name: "Clínica de Teste",
    unit_type_id: unit_type.id
  })

{:ok, user} =
  Simpletask.Accounts.register_user(%{
    email: "marcelo@powertask.com.br",
    password: "local@123456",
    name: "Marcelo Reichert",
    unit_id: unit.id
  })

{:ok, user2} =
  Simpletask.Accounts.register_user(%{
    email: "marcelo2@powertask.com.br",
    password: "local@123456",
    name: "Marcelo Reichert",
    unit_id: unit.id
  })

Repo.insert!(%Simpletask.Rooms.Room{
  name: "Sala de Atendimento 1",
  unit_id: unit.id,
  user_id: user.id
})

Repo.insert!(%Simpletask.Rooms.Room{
  name: "Sala da Clinica de Teste",
  unit_id: unit2.id,
  user_id: user2.id
})
