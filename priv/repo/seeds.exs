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

particular_logo = """
<svg width="400" height="400" viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
  <rect width="400" height="400" rx="20" fill="#ffffff"/>
  <circle cx="200" cy="160" r="100" fill="#0F6E56"/>
  <circle cx="200" cy="130" r="28" fill="#E1F5EE"/>
  <path d="M148 206 Q148 178 200 178 Q252 178 252 206" fill="#E1F5EE"/>
  <polyline points="148,240 162,240 168,222 180,260 192,210 204,260 212,240 234,240 252,240"
            fill="none" stroke="#E1F5EE" stroke-width="5" stroke-linejoin="round" stroke-linecap="round"/>
  <text x="200" y="300" font-family="Arial, sans-serif" font-size="22" font-weight="400"
        fill="#0F6E56" text-anchor="middle">CONSULTA</text>
  <text x="200" y="332" font-family="Arial, sans-serif" font-size="26" font-weight="700"
        fill="#0F6E56" text-anchor="middle" letter-spacing="3">PARTICULAR</text>
</svg>
"""

professional_types = [
  %{name: "Médico", description: "Profissional com formação em medicina habilitado para diagnóstico e tratamento de doenças."},
  %{name: "Enfermeiro", description: "Profissional responsável pelo cuidado e assistência de enfermagem ao paciente."},
  %{name: "Fisioterapeuta", description: "Especialista em reabilitação física e prevenção de disfunções do movimento."},
  %{name: "Psicólogo", description: "Profissional habilitado para avaliação e intervenção em saúde mental."},
  %{name: "Nutricionista", description: "Especialista em alimentação, nutrição e promoção da saúde nutricional."},
  %{name: "Odontólogo", description: "Profissional especializado em saúde bucal, prevenção e tratamento de doenças dentárias."},
  %{name: "Fonoaudiólogo", description: "Especialista em comunicação humana e distúrbios de linguagem, voz e audição."},
  %{name: "Terapeuta Ocupacional", description: "Profissional que promove a autonomia e qualidade de vida por meio de atividades terapêuticas."},
  %{name: "Farmacêutico", description: "Especialista em medicamentos, com atuação em farmácia clínica e orientação farmacoterapêutica."},
  %{name: "Biomédico", description: "Profissional habilitado para análises clínicas, diagnóstico laboratorial e pesquisa biomédica."}
]

Enum.each(professional_types, fn attrs ->
  Repo.insert!(%Simpletask.Schemas.ProfessionalTypeSchema{
    name: attrs.name,
    description: attrs.description
  })
end)

Repo.insert!(%Simpletask.Schemas.HealthInsuranceSchema{name: "Unimed"})
Repo.insert!(%Simpletask.Schemas.HealthInsuranceSchema{name: "Bradesco"})
Repo.insert!(%Simpletask.Schemas.HealthInsuranceSchema{name: "Particular", logo: particular_logo})

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
    name: "Ambulatórios da Clinica de Apoio",
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
    name: "Pediatria",
    cbo_number: "2251-35",
    description:
      "Os pediatras são médicos especializados no desenvolvimento, diagnóstico, tratamento e prevenção de doenças em bebês, crianças e adolescentes. Eles acompanham o crescimento e o desenvolvimento dos jovens pacientes, atendendo a suas necessidades físicas, emocionais e sociais."
  })

specialty3 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Psicologia",
    cbo_number: "2515-05",
    description: "..."
  })

specialty4 =
  Repo.insert!(%Simpletask.Schemas.SpecialtySchema{
    name: "Psicanalista",
    cbo_number: "2515-05",
    description: "..."
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

patients = [
  %{name: "Ana Clara Souza",         phone_ddd: "11", phone_number: "98234-5671", email: "ana.clara@email.com"},
  %{name: "Bruno Ferreira Lima",     phone_ddd: "21", phone_number: "97812-3490", email: "bruno.lima@email.com"},
  %{name: "Carla Mendes Rocha",      phone_ddd: "31", phone_number: "99123-4567", email: "carla.rocha@email.com"},
  %{name: "Diego Alves Pereira",     phone_ddd: "41", phone_number: "98456-7890", email: "diego.pereira@email.com"},
  %{name: "Elisa Martins Costa",     phone_ddd: "51", phone_number: "97345-6789", email: "elisa.costa@email.com"},
  %{name: "Felipe Nunes Barbosa",    phone_ddd: "61", phone_number: "99678-1234", email: "felipe.barbosa@email.com"},
  %{name: "Gabriela Torres Silva",   phone_ddd: "71", phone_number: "98901-2345", email: "gabriela.silva@email.com"},
  %{name: "Henrique Oliveira Cruz",  phone_ddd: "81", phone_number: "97234-5678", email: "henrique.cruz@email.com"},
  %{name: "Isabela Ramos Vieira",    phone_ddd: "85", phone_number: "99012-3456", email: "isabela.vieira@email.com"},
  %{name: "João Pedro Nascimento",   phone_ddd: "11", phone_number: "98567-8901", email: "joao.nascimento@email.com"},
  %{name: "Karen Lopes Moreira",     phone_ddd: "21", phone_number: "97890-1234", email: "karen.moreira@email.com"},
  %{name: "Lucas Carvalho Pinto",    phone_ddd: "31", phone_number: "99321-6543", email: "lucas.pinto@email.com"},
  %{name: "Mariana Freitas Dias",    phone_ddd: "41", phone_number: "98654-3210", email: "mariana.dias@email.com"},
  %{name: "Nicolas Araújo Santos",   phone_ddd: "51", phone_number: "97987-6543", email: "nicolas.santos@email.com"},
  %{name: "Olivia Campos Teixeira",  phone_ddd: "61", phone_number: "99111-2233", email: "olivia.teixeira@email.com"}
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
