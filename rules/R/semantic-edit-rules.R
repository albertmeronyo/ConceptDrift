library(editrules)

people <- read.csv("~/src/ConceptDrift/rules/people.csv")
E <- editset(c("age >=0", "age <= 150"))
E
ve <- violatedEdits(E, people)
ve

E <- editfile("~/src/ConceptDrift/rules/edits.txt")
E
ve <- violatedEdits(E, people)
ve
summary(ve)
plot(ve)
plot(E)

id <- c(2, 5)
people[id, ]
violatedEdits(E, people[id, ])
# Minimum set of variables to adapt
le <- localizeErrors(E, people[id, ], method = "mip")
le$adapt

# Correcting these :-)
people[2, "status"] <- "single"
people[5, "height"] <- 7
people[5, "agegroup"] <- "adult"
summary(violatedEdits(E, people[id, ]))
