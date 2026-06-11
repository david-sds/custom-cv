#let data = yaml("resume.yaml")

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

#show link: underline


#let keywords = data.skills.map(skill => skill.keywords).flatten()
#for keyword in keywords {
  show keywords.first(): emph
}

#let keywords = data.skills.map(skill => skill.keywords).flatten()
#show regex("\b(" + keywords.join("|") + ")\b"): it => emph(it)

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

#let format-phone(num) = {
  let clean = num.replace(regex("\D"), "")
  clean.replace(regex("^(\d{2})(\d{2})(\d{5})(\d{4})$"), m => {
    "+" + m.captures.at(0) + " (" + m.captures.at(1) + ") " + m.captures.at(2) + "-" + m.captures.at(3)
  })
}

= *David Sathler de Siqueira* -- *Full-Stack Developer*

#{
  let items = (
    link("mailto:" + data.basics.email)[#data.basics.email],
    link("tel:" + data.basics.phone)[#format-phone(data.basics.phone)],
    link(data.basics.profiles.find(e => e.network == "LinkedIn").url)[#"LinkedIn"],
    link(data.basics.profiles.find(e => e.network == "Github").url)[#"Github"],
  )
  items.filter(x => x != none).join(" | ")
}

== *Summary*
#data.basics.summary

== *Professional Experience*

#{
  for exp in data.work {
    [ === #{ exp.name } ]
    space-time(
      strong(exp.location),
      [
        #date-range(
          datetime(
            year: int(exp.startDate.split("-").at(0)),
            month: int(exp.startDate.split("-").at(1)),
            day: int(exp.startDate.split("-").at(2)),
          ),
          if "endDate" in exp {
            datetime(
              year: int(exp.endDate.split("-").at(0)),
              month: int(exp.endDate.split("-").at(1)),
              day: int(exp.endDate.split("-").at(2)),
            )
          } else {
            none
          },
        )
      ],
    )
    for topic in exp.highlights {
      [- #{ topic }]
    }
  }
}

== *Education*

#{
  for exp in data.education {
    [ === #{ exp.studyType } -- #{ exp.area }  ]
    space-time(
      strong(exp.institution),
      [
        #date-range(
          datetime(
            year: int(exp.startDate.split("-").at(0)),
            month: int(exp.startDate.split("-").at(1)),
            day: int(exp.startDate.split("-").at(2)),
          ),
          if "endDate" in exp {
            datetime(
              year: int(exp.endDate.split("-").at(0)),
              month: int(exp.endDate.split("-").at(1)),
              day: int(exp.endDate.split("-").at(2)),
            )
          } else {
            none
          },
        )
      ],
    )
    [Focus of Study: #exp.courses.join(", ").]
  }
}

== *Skills and Tools*

#table(
  columns: (auto, auto),
  align: horizon,
  table.header([*Category*], [*Skills & Tools*]),
  ..data
    .skills
    .map(skill => (
      skill.name,
      [#skill.keywords.join(", ").],
    ))
    .flatten(),
)
