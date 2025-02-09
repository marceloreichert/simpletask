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
    name: "Clínica de Apoio",
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
  name: "Sala da Clinica de Apoio",
  unit_id: unit2.id,
  user_id: user2.id
})

specialty1 =
  Repo.insert!(%Simpletask.Specialties.Specialty{
    name: "Cardiologista",
    description:
      "Os cardiologistas são médicos especializados no diagnóstico, tratamento e prevenção de doenças do coração e do sistema cardiovascular. Eles lidam com uma variedade de condições, incluindo hipertensão, arritmias, insuficiência cardíaca, e doenças coronarianas",
    cbo_number: "2251-25"
  })

specialty2 =
  Repo.insert!(%Simpletask.Specialties.Specialty{
    name: "Pediatra",
    cbo_number: "2251-35",
    description:
      "Os pediatras são médicos especializados no desenvolvimento, diagnóstico, tratamento e prevenção de doenças em bebês, crianças e adolescentes. Eles acompanham o crescimento e o desenvolvimento dos jovens pacientes, atendendo a suas necessidades físicas, emocionais e sociais."
  })

specialty3 =
  Repo.insert!(%Simpletask.Specialties.Specialty{
    name: "Psicólogo",
    cbo_number: "2515-05",
    description: "..."
  })

Repo.insert!(%Simpletask.Professionals.Professional{
  name: "Marcelo Reichert",
  unit_id: unit.id,
  specialty_id: specialty3.id
})

Repo.insert!(%Simpletask.Professionals.Professional{
  name: "Médico da Unit 2",
  unit_id: unit2.id,
  specialty_id: specialty2.id
})
