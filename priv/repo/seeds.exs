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

unimed_logo = """
<svg width="400" height="160" viewBox="0 0 400 160" xmlns="http://www.w3.org/2000/svg">
  <rect width="400" height="160" fill="#ffffff"/>
  <rect x="16" y="55" width="60" height="20" rx="4" fill="#00a859"/>
  <rect x="36" y="35" width="20" height="60" rx="4" fill="#00a859"/>
  <text x="96" y="102" font-family="Arial, sans-serif" font-size="56" font-weight="700" fill="#00a859">UNIMED</text>
</svg>
"""

bradesco_logo = """
<svg width="400" height="160" viewBox="0 0 400 160" xmlns="http://www.w3.org/2000/svg">
  <rect width="400" height="160" fill="#ffffff"/>
  <circle cx="44" cy="80" r="36" fill="#cc0000"/>
  <circle cx="44" cy="80" r="22" fill="#ffffff"/>
  <circle cx="44" cy="80" r="12" fill="#cc0000"/>
  <text x="96" y="102" font-family="Arial, sans-serif" font-size="48" font-weight="700" fill="#cc0000">BRADESCO</text>
</svg>
"""

particular_logo = """
<svg width="3500" height="1500" viewBox="0 0 3500 1500" xmlns="http://www.w3.org/2000/svg">
  <rect width="3500" height="1500" fill="#ffffff"/>
  <text x="1750" y="580"
    font-family="Arial, sans-serif"
    font-size="490"
    font-weight="400"
    fill="#0F6E56"
    text-anchor="middle"
    textLength="3380"
    lengthAdjust="spacing">CONSULTA</text>
  <text x="1750" y="1190"
    font-family="Arial Black, Arial, sans-serif"
    font-size="490"
    font-weight="900"
    fill="#0F6E56"
    text-anchor="middle"
    textLength="3380"
    lengthAdjust="spacing">PARTICULAR</text>
  <rect x="60" y="1330" width="3380" height="27" rx="14" fill="#0F6E56" opacity="0.4"/>
</svg>
"""

professional_types = [
  %{
    name: "Médico",
    description:
      "Profissional com formação em medicina habilitado para diagnóstico e tratamento de doenças."
  },
  %{
    name: "Enfermeiro",
    description: "Profissional responsável pelo cuidado e assistência de enfermagem ao paciente."
  },
  %{
    name: "Fisioterapeuta",
    description: "Especialista em reabilitação física e prevenção de disfunções do movimento."
  },
  %{
    name: "Psicólogo",
    description: "Profissional habilitado para avaliação e intervenção em saúde mental."
  },
  %{
    name: "Nutricionista",
    description: "Especialista em alimentação, nutrição e promoção da saúde nutricional."
  },
  %{
    name: "Odontólogo",
    description:
      "Profissional especializado em saúde bucal, prevenção e tratamento de doenças dentárias."
  },
  %{
    name: "Fonoaudiólogo",
    description: "Especialista em comunicação humana e distúrbios de linguagem, voz e audição."
  },
  %{
    name: "Terapeuta Ocupacional",
    description:
      "Profissional que promove a autonomia e qualidade de vida por meio de atividades terapêuticas."
  },
  %{
    name: "Farmacêutico",
    description:
      "Especialista em medicamentos, com atuação em farmácia clínica e orientação farmacoterapêutica."
  },
  %{
    name: "Biomédico",
    description:
      "Profissional habilitado para análises clínicas, diagnóstico laboratorial e pesquisa biomédica."
  }
]

Enum.each(professional_types, fn attrs ->
  Repo.insert!(%Simpletask.Schemas.ProfessionalTypeSchema{
    name: attrs.name,
    description: attrs.description
  })
end)

hi_unimed =
  Repo.insert!(%Simpletask.Schemas.HealthInsuranceSchema{name: "Unimed", logo: unimed_logo})

hi_bradesco =
  Repo.insert!(%Simpletask.Schemas.HealthInsuranceSchema{name: "Bradesco", logo: bradesco_logo})

hi_particular =
  Repo.insert!(%Simpletask.Schemas.HealthInsuranceSchema{
    name: "Particular",
    logo: particular_logo
  })

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
    email: "marcelo@simpletask.com.br",
    password: "teste@12345678",
    name: "Marcelo Reichert",
    unit_id: unit.id
  })

user =
  Repo.update!(Simpletask.Accounts.User.roles_changeset(user, %{roles: [:master]}))

{:ok, user2} =
  Simpletask.Queries.AccountQuery.register_user(%{
    email: "marcelo2@simpletask.com.br",
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
    name: "Ambulatórios da Clinica de Apoio",
    unit_id: unit2.id
  })

specialty1 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Cardiologista",
    description:
      "Os cardiologistas são médicos especializados no diagnóstico, tratamento e prevenção de doenças do coração e do sistema cardiovascular. Eles lidam com uma variedade de condições, incluindo hipertensão, arritmias, insuficiência cardíaca, e doenças coronarianas",
    cbo_number: "2251-25",
    scheduling_allowed: true
  })

specialty2 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Pediatria",
    cbo_number: "2251-35",
    description:
      "Os pediatras são médicos especializados no desenvolvimento, diagnóstico, tratamento e prevenção de doenças em bebês, crianças e adolescentes. Eles acompanham o crescimento e o desenvolvimento dos jovens pacientes, atendendo a suas necessidades físicas, emocionais e sociais.",
    scheduling_allowed: true
  })

specialty3 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Psicologia",
    cbo_number: "2515-05",
    description: "...",
    scheduling_allowed: true
  })

specialty4 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Psicanalista",
    cbo_number: "2515-05",
    description: "...",
    scheduling_allowed: true
  })

medico_type = Repo.get_by!(Simpletask.Schemas.ProfessionalTypeSchema, name: "Médico")

pro1 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Marcelo Reichert",
    unit_id: unit.id,
    specialty_id: specialty4.id,
    professional_type_id: medico_type.id,
    schedule_consultation_time: 50,
    schedule_time_between_consultation: 10
  })

pro2 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Médico da Unit 2",
    unit_id: unit2.id,
    specialty_id: specialty2.id,
    professional_type_id: medico_type.id,
    schedule_consultation_time: 30,
    schedule_time_between_consultation: 5
  })

pro3 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Lorena Azevedo",
    unit_id: unit.id,
    specialty_id: specialty2.id,
    professional_type_id: medico_type.id,
    schedule_consultation_time: 30,
    schedule_time_between_consultation: 5
  })

Repo.insert!(%Simpletask.Schemas.ProfessionalSectorSchema{
  sector_id: sector1.id,
  modality_id: modality1.id,
  professional_id: pro1.id
})

pro4 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Rafael Cardoso Melo",
    unit_id: unit.id,
    specialty_id: specialty1.id,
    professional_type_id: medico_type.id,
    schedule_consultation_time: 20,
    schedule_time_between_consultation: 5
  })

pro5 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Fernanda Queiroz Lima",
    unit_id: unit.id,
    specialty_id: specialty2.id,
    professional_type_id: medico_type.id,
    schedule_consultation_time: 30,
    schedule_time_between_consultation: 10
  })

pro6 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Thiago Borges Andrade",
    unit_id: unit.id,
    specialty_id: specialty3.id,
    professional_type_id: medico_type.id,
    schedule_consultation_time: 50,
    schedule_time_between_consultation: 10
  })

pro7 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Juliana Pires Ventura",
    unit_id: unit.id,
    specialty_id: specialty1.id,
    professional_type_id: medico_type.id,
    schedule_consultation_time: 20,
    schedule_time_between_consultation: 5
  })

pro8 =
  Repo.insert!(%Simpletask.Schemas.ProfessionalSchema{
    name: "Eduardo Siqueira Neto",
    unit_id: unit.id,
    specialty_id: specialty4.id,
    professional_type_id: medico_type.id,
    schedule_consultation_time: 50,
    schedule_time_between_consultation: 10
  })

{:ok, _} = Simpletask.Queries.AccountQuery.update_user_professional(user.id, pro1.id)

{:ok, lorena_user} =
  Simpletask.Queries.AccountQuery.register_user(%{
    email: "lorena@simpletask.com.br",
    password: "teste@12345678",
    name: "Lorena Azevedo",
    unit_id: unit.id
  })

Repo.update!(Simpletask.Accounts.User.roles_changeset(lorena_user, %{roles: [:admin]}))
{:ok, _} = Simpletask.Queries.AccountQuery.update_user_professional(lorena_user.id, pro3.id)

{:ok, recepcao_user} =
  Simpletask.Queries.AccountQuery.register_user(%{
    email: "recepcao@simpletask.com.br",
    password: "teste@12345678",
    name: "Usuário da Recepção",
    unit_id: unit.id
  })

Repo.update!(Simpletask.Accounts.User.roles_changeset(recepcao_user, %{roles: [:attend]}))

patients = [
  %{
    name: "Ana Clara Souza",
    phone_ddd: "11",
    phone_number: "98234-5671",
    email: "ana.clara@email.com"
  },
  %{
    name: "Bruno Ferreira Lima",
    phone_ddd: "21",
    phone_number: "97812-3490",
    email: "bruno.lima@email.com"
  },
  %{
    name: "Carla Mendes Rocha",
    phone_ddd: "31",
    phone_number: "99123-4567",
    email: "carla.rocha@email.com"
  },
  %{
    name: "Diego Alves Pereira",
    phone_ddd: "41",
    phone_number: "98456-7890",
    email: "diego.pereira@email.com"
  },
  %{
    name: "Elisa Martins Costa",
    phone_ddd: "51",
    phone_number: "97345-6789",
    email: "elisa.costa@email.com"
  },
  %{
    name: "Felipe Nunes Barbosa",
    phone_ddd: "61",
    phone_number: "99678-1234",
    email: "felipe.barbosa@email.com"
  },
  %{
    name: "Gabriela Torres Silva",
    phone_ddd: "71",
    phone_number: "98901-2345",
    email: "gabriela.silva@email.com"
  },
  %{
    name: "Henrique Oliveira Cruz",
    phone_ddd: "81",
    phone_number: "97234-5678",
    email: "henrique.cruz@email.com"
  },
  %{
    name: "Isabela Ramos Vieira",
    phone_ddd: "85",
    phone_number: "99012-3456",
    email: "isabela.vieira@email.com"
  },
  %{
    name: "João Pedro Nascimento",
    phone_ddd: "11",
    phone_number: "98567-8901",
    email: "joao.nascimento@email.com"
  },
  %{
    name: "Karen Lopes Moreira",
    phone_ddd: "21",
    phone_number: "97890-1234",
    email: "karen.moreira@email.com"
  },
  %{
    name: "Lucas Carvalho Pinto",
    phone_ddd: "31",
    phone_number: "99321-6543",
    email: "lucas.pinto@email.com"
  },
  %{
    name: "Mariana Freitas Dias",
    phone_ddd: "41",
    phone_number: "98654-3210",
    email: "mariana.dias@email.com"
  },
  %{
    name: "Nicolas Araújo Santos",
    phone_ddd: "51",
    phone_number: "97987-6543",
    email: "nicolas.santos@email.com"
  },
  %{
    name: "Olivia Campos Teixeira",
    phone_ddd: "61",
    phone_number: "99111-2233",
    email: "olivia.teixeira@email.com"
  }
]

Enum.each(patients, fn attrs ->
  Repo.insert!(%Simpletask.Schemas.PatientSchema{
    name: attrs.name,
    phone_ddd: attrs.phone_ddd,
    phone_number: attrs.phone_number,
    email: attrs.email,
    unit_id: unit.id
  })
end)

# Agenda para Marcelo Reichert — dia corrente, todos os convênios, 08:00–22:00
today = DateTime.now!("America/Sao_Paulo") |> DateTime.to_date()

{:ok, _} =
  Simpletask.Queries.ScheduleQuery.create_schedule(%{
    schedule_date: today,
    schedule_time_start: ~T[08:00:00],
    schedule_time_end: ~T[22:00:00],
    schedule_consultation_time: pro1.schedule_consultation_time,
    schedule_time_between_consultation: pro1.schedule_time_between_consultation,
    schedule_type: "health_insurance",
    health_insurance_ids: [hi_unimed.id, hi_bradesco.id, hi_particular.id],
    professional_id: pro1.id,
    room_id: room1.id,
    unit_id: unit.id
  })
