#set page(
  paper: "a4",
)
#set text(
  font: "New Computer Modern",
  size: 10pt,
)
#set par(
  justify: true,
)
#set line(length: 100%, stroke: 0.5pt)

#show heading.where(level: 2): it => [
  #pad(top: 10pt, bottom: -10pt, [#smallcaps(it.body)])
  #line(length: 100%, stroke: 1pt)
]

#let term = (
  dart: emph("Dart"),
  flutter: emph("Flutter"),
  vue: emph("Vue.js"),
  nest: emph("NestJS"),
  java: emph("Java"),
  mysql: emph("MySQL"),
  postgres: emph("PostgreSQL"),
  prisma: emph("Prisma ORM"),
  linux: emph("Linux"),
  docker: emph("Docker"),
  cicd: emph("CI/CD"),
  gitlabCI: emph("GitLab CI"),
  githubActions: emph("GitHub Actions"),
  moodle: emph("Moodle"),
  vps: emph("VPS"),
  nginx: emph("Nginx"),
  hostgator: emph("Hostgator"),
  hostinger: emph("Hostinger"),
  gcp: (storage: emph("Firebase Storage"), firestore: emph("Firestore Database")),
  scrum: (pocker: emph("Scrum Pocker")),
  quasar: emph("Quasar Framework"),
  couchdb: emph("CouchDb"),
  mfe: emph("Micro-frontends"),
  accessibility: emph("Accessibility"),
  codeSmells: emph("Code Smells"),
  antiPatterns: emph("Anti-patterns"),
  refactoring: emph("Refactoring"),
  staticAnalysis: emph("Static Analysis"),
  dataStructures: emph("Data Structures"),
  dataModeling: emph("Data Modeling"),
  oop: emph("Object-Oriented Programming (OOP)"),
  functionalProgramming: emph("Functional Programming"),
  softwareArchitecture: emph("Software Architecture"),
  softwareAnalysis: emph("Software Analysis"),
  math: emph("Mathematics"),
  programmingLogic: emph("Programming Logic"),
  cs: emph("Computer Science"),
  react: emph("React"),
  node: emph("Node.js"),
  git: emph("Git"),
  ts: emph("Typescript"),
  js: emph("Javascript"),
  bash: emph("Bash"),
  neovim: emph("Neovim"),
)

#let duration-text(start, end) = {
  let total = (end.year() - start.year()) * 12 + (end.month() - start.month()) + 1
  let years = calc.quo(total, 12)
  let months = calc.rem(total, 12)

  let year-label = (
    str(years)
      + if years > 1 {
        " years"
      } else {
        " year"
      }
  )

  let month-label = (
    str(months)
      + if months > 1 {
        " months"
      } else {
        " month"
      }
  )

  if years > 0 {
    year-label
  }
  if years > 0 and months > 0 {
    " and "
  }
  if months > 0 {
    month-label
  }
}

#let date-range(start, end) = {
  let fmt = "[month repr:short] [year]"
  let start-fmt = start.display(fmt)
  let end-fmt = if end == none { "Present" } else { end.display(fmt) }
  let duration-fmt = if end == none { "" } else { "(" + duration-text(start, end) + ")" }
  // emph(start-fmt + " – " + end-fmt + " " + duration-fmt)
  emph(start-fmt + " – " + end-fmt + " " + duration-fmt)
}

#let space-time(left, right) = grid(
  columns: (auto, 1fr, auto),
  column-gutter: 0.6em,
  align: bottom,
  [#left],
  line(
    stroke: (thickness: 0.8pt, dash: "dotted"),
  ),
  [#right],
)

= *David Sathler de Siqueira* -- *Full-Stack Developer*

#{
  let items = (
    link("mailto:dave.sathler@gmail.com")[#"dave.sathler@gmail.com"],
    link("tel:+5571999672365")[#"+55 (41) 99967-2365"],
    link("https://www.linkedin.com/in/david-sds")[#"LinkedIn"],
    link("https://www.github.com/david-sds")[#"Github"],
  )
  items.filter(x => x != none).join(" | ")
}

== *Summary*
Fullstack Developer focused on modern mobile/web development technologies (#term.flutter, #term.vue) and back-end (#term.nest, #term.java). Strong experience in software architecture, data modeling (#term.mysql, #term.postgres, #term.prisma), and proficiency in server environment administration and DevOps practices (#term.linux, #term.docker, #term.cicd). I aim to optimize the entire software lifecycle process, from conception to production and maintenance.

== *Professional Experience*

=== *Fullstack Developer (Part-time employee)*
#space-time(
  [ *Fagundez Tecnologia - HOTMILK* ],
  [
    #date-range(datetime(year: 2026, month: 1, day: 1), none)
  ],
)
- Participated in the migration of the #term.cicd pipeline from #term.gitlabCI to #term.githubActions.
- Integrated and deployed #term.moodle running on the #term.vps infrastructure with #term.docker and #term.nginx.

=== *Fullstack Developer (Research Grant)*
#space-time(
  [ *Fagundez Tecnologia - HOTMILK* ],
  [
    #date-range(
      datetime(year: 2025, month: 1, day: 1),
      datetime(year: 2025, month: 12, day: 31),
    )
  ],
)
- Took full responsibility for back-end development and maintenance using the #term.nest framework.
- Managed the #term.mysql database using #term.prisma for data modeling and migrations.
- Maintained and optimized the #term.cicd pipeline using #term.gitlabCI.
- Administered the #term.vps (#term.hostgator), orchestrating the deployment and production environment with #term.docker.

=== *Frontend Developer (Research Grant)*
#space-time([ *Fagundez Tecnologia - HOTMILK* ], [
  #date-range(
    datetime(year: 2023, month: 5, day: 1),
    datetime(year: 2024, month: 12, day: 31),
  )
])
- Led the initial development of an educational project management application (Web and Mobile) using #term.flutter.
- Clarified requirements and business rules through in-person meetings with the client.
- Integrated APIs and collaborated asynchronously with back-end developers.
- Implemented image storage and retrieval integration using #term.gcp.storage.


=== *Fullstack Developer (Intership)*
#space-time([*Videnci - Remoto*], [
  #date-range(
    datetime(year: 2021, month: 12, day: 1),
    datetime(year: 2022, month: 12, day: 1),
  )
])
- Worked in a startup as part of a remote agile team applying practices such as #term.scrum.pocker, testing (manual and automated), code review, and daily meetings.
- Developed responsive interfaces and managed dynamic state in web and mobile applications using #term.vue (#term.quasar).
- Debugged legacy code and complex #term.java functions.
- Solved issues in complex document synchronization flows with #term.couchdb.

== *Education*

=== *Master’s Degree – Software Engineering (Incomplete)*
#space-time([*Pontifical Catholic University of Paraná*], [
  #date-range(
    datetime(year: 2024, month: 1, day: 1),
    datetime(year: 2025, month: 6, day: 30),
  )
])
Focus of Study: #term.mfe, #term.accessibility, #term.codeSmells, #term.antiPatterns, #term.refactoring and #term.staticAnalysis.

=== *Bachelor’s Degree in Information Systems*
#space-time([*Pontifical Catholic University of Paraná*], [
  #date-range(
    datetime(year: 2020, month: 1, day: 1),
    datetime(year: 2023, month: 12, day: 31),
  )
])
Focus of Study: #term.dataStructures, #term.dataModeling, #term.oop, #term.functionalProgramming, #term.softwareArchitecture and #term.softwareAnalysis.

=== *Mathematics and Computer Science*
#space-time([*Khan Academy*], [ #date-range(
    datetime(year: 2017, month: 1, day: 1),
    datetime(year: 2020, month: 6, day: 30),
  )
])
Focus of Study: Mathematics, Programming Logic, Introduction to Computer Science. #term.math, #term.programmingLogic and introduction to #term.cs.

== *Skills and Tools*

#table(
  columns: (auto, auto),
  align: horizon,
  table.header([*Category*], [*Skills & Tools*]),
  "Front-end & Mobile", [#term.flutter, #term.vue, #term.quasar, #term.react.],
  "Back-end", [#term.nest, #term.node, #term.java, #term.prisma, #term.couchdb.],
  "Bancos de Dados", [ #term.mysql, #term.postgres, #term.gcp.firestore, #term.couchdb. ],
  "Infra & DevOps", [ #term.linux, #term.docker, #term.nginx, #term.gitlabCI, #term.githubActions. ],
  "Languages", [ Advanced English, Beginner Japanese ],
  "Other", [ #term.git, #term.gcp.storage, #term.ts, #term.bash, #term.neovim. ],
)
