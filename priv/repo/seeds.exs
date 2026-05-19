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

modality1 =
  Repo.insert!(%Simpletask.Schemas.ModalitySchema{
    name: "Clínica/Ambulatório"
  })

modality2 =
  Repo.insert!(%Simpletask.Schemas.ModalitySchema{
    name: "Hospital"
  })

unit =
  Repo.insert!(%Simpletask.Schemas.UnitSchema{
    name: "Clínica Amendoim Quasqualho",
    modality_id: modality1.id
  })

unit2 =
  Repo.insert!(%Simpletask.Schemas.UnitSchema{
    name: "Clínica de Apoio",
    modality_id: modality2.id
  })

{:ok, user} =
  Simpletask.Queries.AccountQuery.register_user(%{
    email: "marcelo@powertask.com.br",
    password: "teste@12345678",
    name: "Marcelo Reichert",
    unit_id: unit.id
  })

{:ok, user2} =
  Simpletask.Queries.AccountQuery.register_user(%{
    email: "marcelo2@powertask.com.br",
    password: "teste@12345678",
    name: "Marcelo Reichert",
    unit_id: unit.id
  })

room1 =
  Repo.insert!(%Simpletask.Schemas.RoomSchema{
    name: "Sala de Atendimento 1",
    unit_id: unit.id,
    user_id: user.id
  })

room2 =
  Repo.insert!(%Simpletask.Schemas.RoomSchema{
    name: "Sala da Clinica de Apoio",
    unit_id: unit2.id,
    user_id: user2.id
  })

sector1 =
  Repo.insert!(%Simpletask.Schemas.SectorSchema{
    name: "Ambulatórios",
    unit_id: unit.id
  })

sector2 =
  Repo.insert!(%Simpletask.Schemas.SectorSchema{
    name: "Ambulatórios",
    unit_id: unit2.id
  })

specialty1 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Cardiologista",
    description:
      "Os cardiologistas são médicos especializados no diagnóstico, tratamento e prevenção de doenças do coração e do sistema cardiovascular. Eles lidam com uma variedade de condições, incluindo hipertensão, arritmias, insuficiência cardíaca, e doenças coronarianas",
    cbo_number: "2251-25"
  })

specialty2 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Pediatra",
    cbo_number: "2251-35",
    description:
      "Os pediatras são médicos especializados no desenvolvimento, diagnóstico, tratamento e prevenção de doenças em bebês, crianças e adolescentes. Eles acompanham o crescimento e o desenvolvimento dos jovens pacientes, atendendo a suas necessidades físicas, emocionais e sociais."
  })

specialty3 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Psicólogo",
    cbo_number: "2515-05",
    description: "..."
  })

specialty4 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Psicanalise",
    cbo_number: "2515-05",
    description: "..."
  })

pro1 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Marcelo Reichert",
    unit_id: unit.id,
    specialty_id: specialty4.id
  })

pro2 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Médico da Unit 2",
    unit_id: unit2.id,
    specialty_id: specialty2.id
  })

pro3 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Lorena Azevedo",
    unit_id: unit.id,
    specialty_id: specialty2.id
  })

Repo.insert!(%Simpletask.Schemas.ProfessionalSectorSchema{
  sector_id: sector1.id,
  modality_id: modality1.id,
  professional_id: pro1.id
})

Repo.insert!(%Simpletask.Schemas.ProfessionalSectorSchema{
  sector_id: sector1.id,
  modality_id: modality1.id,
  professional_id: pro1.id
})

patients = [
  %{name: "Ana Clara Souza",       phone_ddd: "11", phone_number: "98234-5671"},
  %{name: "Bruno Ferreira Lima",   phone_ddd: "21", phone_number: "97812-3490"},
  %{name: "Carla Mendes Rocha",    phone_ddd: "31", phone_number: "99123-4567"},
  %{name: "Diego Alves Pereira",   phone_ddd: "41", phone_number: "98456-7890"},
  %{name: "Elisa Martins Costa",   phone_ddd: "51", phone_number: "97345-6789"},
  %{name: "Felipe Nunes Barbosa",  phone_ddd: "61", phone_number: "99678-1234"},
  %{name: "Gabriela Torres Silva", phone_ddd: "71", phone_number: "98901-2345"},
  %{name: "Henrique Oliveira Cruz",phone_ddd: "81", phone_number: "97234-5678"},
  %{name: "Isabela Ramos Vieira",  phone_ddd: "85", phone_number: "99012-3456"},
  %{name: "João Pedro Nascimento", phone_ddd: "11", phone_number: "98567-8901"},
  %{name: "Karen Lopes Moreira",   phone_ddd: "21", phone_number: "97890-1234"},
  %{name: "Lucas Carvalho Pinto",  phone_ddd: "31", phone_number: "99321-6543"},
  %{name: "Mariana Freitas Dias",  phone_ddd: "41", phone_number: "98654-3210"},
  %{name: "Nicolas Araújo Santos", phone_ddd: "51", phone_number: "97987-6543"},
  %{name: "Olivia Campos Teixeira",phone_ddd: "61", phone_number: "99111-2233"}
]

Enum.each(patients, fn attrs ->
  Repo.insert!(%Simpletask.Schemas.PatientSchema{
    name: attrs.name,
    phone_ddd: attrs.phone_ddd,
    phone_number: attrs.phone_number,
    unit_id: unit.id
  })
end)
