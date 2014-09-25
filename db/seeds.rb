# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

dionysus = Person.create(name: 'Dionysus')
athena = Person.create(name: 'Athena')
artemis = Person.create(name: 'Artemis')
zeus = Person.create(name: 'Zeus')
hermes = Person.create(name: 'Hermes')
admin = Person.create(name: 'Hera')

budget = Budget.create(name: 'Pantheon')

round = Round.create(budget: budget)

RoundProject.create(
  round: round,
  project: Project.create(
    budget: budget,
    name: 'Rescue Persephone from Hades',
    description: "I'd really like someone to rescue my daughter from the underworld. Hades isn't returning my calls, and I'm busy on Earth doing, um, important business.",
    min_cents: 1000,
    max_cents: rand(2000..9000),
    #sponsor: zeus,
  )
)

RoundProject.create(
  round: round,
  project: Project.create(
    budget: budget,
    name: 'Build Website',
    description: "We are aiming to raise around $5k in total by end of the year to pay Aphodite (design) & Ares (dev) to refresh the design and build the site on wordpress.",
    min_cents: rand(1..1000),
    max_cents: rand(1000..9000),
    #sponsor: nil,
  )
)

RoundProject.create(
  round: round,
  project: Project.create(
    budget: budget,
    name: 'Foosball table for Acropolis',
    description: "This would be a great way for us to spend our time rather than annoying the mortals.",
    min_cents: rand(1..9000),
    max_cents: rand(1..9000),
    #sponsor: artemis,
  )
)

RoundProject.create(
  round: round,
  project: Project.create(
    name: 'Wine for all',
    description: "Everyone around here just needs to relax.",
    min_cents: 0,
    max_cents: rand(100..900),
    #sponsor: dionysus
  )
)
