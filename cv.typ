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

= *David Sathler de Siqueira*
== *Full-Stack Developer*

#{
  let items = (
    link("mailto:dave.sathler@gmail.com")[#"dave.sathler@gmail.com"],
    link("tel:+5571999672365")[#"+55 (41) 99967-2365"],
    link("https://www.linkedin.com/in/david-sds")[#"LinkedIn"],
    link("https://www.github.com/david-sds")[#"Github"],
  )
  items.filter(x => x != none).join(" | ")
}

#line()

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

== *Summary*
Fullstack Developer focused on modern mobile/web development technologies (#term.flutter, #term.vue) and back-end (#term.nest, #term.java). Strong experience in software architecture, data modeling (#term.mysql, #term.postgres, #term.prisma), and proficiency in server environment administration and DevOps practices (#term.linux, #term.docker, #term.cicd). I aim to optimize the entire software lifecycle process, from conception to production and maintenance.

#line()

== *Professional Experience*

=== *Fullstack Developer (Part-time employee)*
*Fagundez Tecnologia - HOTMILK* | _Jan 2026 – Present_ \
- Participated in the migration of the #term.cicd pipeline from #term.gitlabCI to #term.githubActions.
- Integrated and deployed #term.moodle running on the #term.vps infrastructure with #term.docker and #term.nginx.

=== *Fullstack Developer (Research Grant)*
*Fagundez Tecnologia - HOTMILK* | _Jan 2025 – Dec 2025 (1 year)_ \
- Took full responsibility for back-end development and maintenance using the #term.nest framework.
- Managed the #term.mysql database using #term.prisma for data modeling and migrations.
- Maintained and optimized the #term.cicd pipeline using #term.gitlabCI.
- Administered the #term.vps (#term.hostgator), orchestrating the deployment and production environment with #term.docker.

=== *Frontend Developer (Research Grant)*
*Fagundez Tecnologia - HOTMILK* | _May 2023 – Dec 2024 (1 year 8 months)_ \
- Led the initial development of an educational project management application (Web and Mobile) using #term.flutter.
- Clarified requirements and business rules through in-person meetings with the client.
- Integrated APIs and collaborated asynchronously with back-end developers.
- Implemented image storage and retrieval integration using #term.gcp.storage.

=== *Fullstack Developer (Intership)*
*Videnci - Remoto* | _Dec 2021 – Dec 2022 (1 year 1 month)_ \
- Worked in a startup as part of a remote agile team applying practices such as #term.scrum.pocker, testing (manual and automated), code review, and daily meetings.
- Developed responsive interfaces and managed dynamic state in web and mobile applications using #term.vue (#term.quasar).
- Debugged legacy code and complex #term.java functions.
- Solved issues in complex document synchronization flows with #term.couchdb.

#line()

== *Education*

=== *Master’s Degree – Software Engineering (Incomplete)*
*Pontifical Catholic University of Paraná (PUCPR)* | _Jan 2024 – Jun 2025_ \
Focus of Study: #term.mfe, #term.accessibility, #term.codeSmells, #term.antiPatterns, #term.refactoring and #term.staticAnalysis.

=== *Bachelor’s Degree in Information Systems*
*Pontifical Catholic University of Paraná (PUCPR)* | _Jan 2020 – Dec 2024._ \
Focus of Study: #term.dataStructures, #term.dataModeling, #term.oop, #term.functionalProgramming, #term.softwareArchitecture and #term.softwareAnalysis.

=== *Mathematics and Computer Science*
*Khan Academy* | _2017 – 2020_ \
Focus of Study: Mathematics, Programming Logic, Introduction to Computer Science. #term.math, #term.programmingLogic and introduction to #term.cs.

#line()

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
