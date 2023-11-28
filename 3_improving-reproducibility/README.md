# Improving reproducibility in animal studies

* [Presentation, PPTX](https://github.com/quadram-institute-bioscience/datasciencegroup/releases/download/2023.10/Improving.The.Reproducibility.of.Animal.Studies.Short.pptx)

```r

# Selection bias in observational studies

# Lets try to understand the correlation between health and wealth.

# Generate a population of people

set.seed(1)
populationsize = 1e4
samplesize = 200

population <- data.frame(health=rnorm(populationsize), wealth=rnorm(populationsize))

# now sample a cohort from this group and test the correlation!

sample1 <- population[sample(populationsize, samplesize),]


## Do a descriptive analysis and test the correlation

plot(sample1$health, sample1$wealth)
cor.test(sample1$health, sample1$wealth)

## All good!


## Now lets draw another sample
## But lets suppose the probability of participating is not the same for everybody.

## We know that healthier, wealthier people are more likely to participate in our studies

population$b_participate = (population$health + population$wealth)
population$prob_participate = exp(population$b_participate) / (1+exp(population$b_participate))

head(population)

sample2 <- population[sample(populationsize, samplesize, prob = population$prob_participate),]

## How will the average health and wealth in our sample compare to the population?
mean(sample2$health)
mean(sample2$wealth)

## What about the correlation between the two variables?
## Will it be (on average) higher, lower, or the same as the true population correlation?
plot(sample2$health, sample2$wealth)
cor.test(sample2$health, sample2$wealth)



## Can you explain what is happening here?
## We could replicate this the same way to test the distribution of p-values..


onepvalue <- function(){
  samplen <- population[sample(populationsize, samplesize, prob = population$prob_participate),]
  cor.test(samplen$health, samplen$wealth)$p.value
}

replicate(1000, onepvalue()) |> hist(breaks=20)
```
