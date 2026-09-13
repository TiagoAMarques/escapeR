# These puzzles adapt the supplied EN2026 lectures; all uncredited numerical
# examples are illustrative teaching data, not empirical ecological findings.
.en_lesson <- function(topic, slides, title, goal, story, challenge, hints,
                       answer, success, digits = NULL) {
  list(topic = topic, slides = slides, title = title, goal = goal,
       story = story, challenge = challenge, hints = hints,
       answer = answer, success = success, digits = digits)
}

.en_number_checker <- function(target, digits) {
  force(target)
  force(digits)
  function(answer) {
    if (length(answer) != 1L ||
        !(is.numeric(answer) || is.character(answer)) || is.complex(answer)) {
      return(FALSE)
    }
    value <- suppressWarnings(as.numeric(answer))
    if (!is.finite(value)) return(FALSE)
    if (is.null(digits) || digits == 0L) return(.num_equal(value, target))
    .num_equal(round(value, digits), round(target, digits))
  }
}

.en_lecture_files <- function() {
  dates <- c("14Sep", "15Sep", "21Sep", "22Sep", "28Sep", "29Sep", "06Oct",
             "12Oct", "13Oct", "19Oct", "20Oct", "26Oct", "27Oct", "02Nov",
             "03Nov", "09Nov", "10Nov", "16Nov", "17Nov", "23Nov", "24Nov",
             "30Nov", "07Dec", "14Dec", "15Dec")
  paste0(ifelse(seq_len(25) <= 2, "Novos/", "Velhos/"),
         sprintf("T%02d_EN_", seq_len(25)), dates, "2026.pptx")
}

.en_class_plan <- function() {
  lessons <- .en_lessons()
  data.frame(
    class = seq_len(25), id = sprintf("en%02d", seq_len(25)),
    topic = c("Introduction and R", vapply(lessons, `[[`, character(1), "topic")),
    goal = c("Use R arithmetic, square roots, and unit conversion to calculate travel time.",
             vapply(lessons, `[[`, character(1), "goal")),
    source = .en_lecture_files(), stringsAsFactors = FALSE
  )
}

.en_lessons <- function() {
  list(
    .en_lesson(
      "Critical thinking and observation filters", 18:24, "The Invisible Birds",
      "Distinguish observed counts from abundance when detection is imperfect.",
      "The teacher's virtual forest hides birds behind leaves. The counter only records the birds you see.",
      "A census records 18 birds. Each bird has detection probability 0.6 and can be counted at most once. Estimate abundance by dividing the observed count by detection probability. Submit the estimated number of birds.",
      c("Expected count = abundance * detection probability: the observed count is a filtered view of abundance.",
        "Rearrange the expression to isolate abundance.",
        "Calculate 18 / 0.6. This estimates abundance; it does not guarantee the true population size."),
      30, "The hidden birds appear. You remembered the filter between reality and observations.", 0L
    ),
    .en_lesson(
      "Scientific questions and falsifiable hypotheses", 36:45, "The River Hypothesis",
      "Translate a falsifiable ecological hypothesis into a numerical prediction.",
      "A virtual river blocks the corridor. The teacher will lower the bridge only after you make a testable prediction.",
      "A proposed model predicts macroinvertebrate abundance as 20 - 3 * current_speed, with current_speed in m/s. Use R to predict abundance at 2 m/s. Submit the predicted count. This model is a hypothesis to test against observations, rather than an established ecological law.",
      c("A model should produce predictions that observations could contradict.",
        "Substitute the specified current speed into the model.", "Calculate 20 - 3 * 2."),
      14, "The bridge lowers. Your hypothesis now makes a prediction that can be tested.", 0L
    ),
    .en_lesson(
      "Variable types and probability rules", 43:50, "The Two Habitat Gates",
      "Calculate the probability of a union without double-counting an intersection.",
      "Two virtual gates are labelled feeding and shelter. Some animals pass through both.",
      "For a randomly selected animal, P(feeding) = 0.4, P(shelter) = 0.5, and P(both) = 0.2. What is the probability it is feeding or sheltering, including animals doing both? Submit the probability.",
      c("Adding the two probabilities counts animals in the intersection twice.",
        "P(A or B) = P(A) + P(B) - P(A and B). Independence is not assumed here.",
        "Calculate 0.4 + 0.5 - 0.2."),
      0.7, "The gates open together. Every animal has been counted once."
    ),
    .en_lesson(
      "Random variables and distributions", 34:41, "The Nest Lottery",
      "Calculate a binomial probability and recognize its assumptions.",
      "The teacher has hidden a key among eight virtual nests. Their outcomes follow a probability model.",
      "Each of 8 independent nests has probability 0.25 of fledging at least one chick. What is the probability exactly 2 nests succeed? Submit the probability rounded to four decimal places.",
      c("There is a fixed number of independent trials, each with two outcomes and the same success probability.",
        "Use the binomial probability mass function dbinom(), rather than the cumulative pbinom().",
        "Calculate round(dbinom(2, size = 8, prob = 0.25), 4)."),
      0.3115, "Two successful nests reveal the key. A probability model helped you find it.", 4L
    ),
    .en_lesson(
      "Distribution functions in R", 13:15, "The Temperature Vault",
      "Use a cumulative distribution function to calculate an upper-tail probability.",
      "A virtual thermometer guards the next door. It opens only when you distinguish a density from a probability.",
      "Assume daily maximum temperature is Normally distributed with mean 20 degrees C and standard deviation 2 degrees C. What is the probability temperature exceeds 24 degrees C? Submit the probability rounded to four decimal places.",
      c("You need the area to the right of 24, rather than the density at 24.",
        "pnorm() gives cumulative probabilities. Use lower.tail = FALSE for an upper tail.",
        "Calculate round(pnorm(24, mean = 20, sd = 2, lower.tail = FALSE), 4)."),
      0.0228, "The vault cools and unlocks. You found a tail area.", 4L
    ),
    .en_lesson(
      "Sampling and stratification", 23:29, "The Unequal Habitats",
      "Weight stratum means by the sizes of the strata.",
      "The virtual reserve contains a large woodland and a small meadow. The teacher hopes you will give them equal weight.",
      "A reserve has 80 woodland quadrats and 20 meadow quadrats, all of equal area. Random samples within each habitat give mean counts of 10 and 30 plants per quadrat, respectively. Estimate the mean count per quadrat across the whole reserve. Submit the weighted mean.",
      c("The habitats represent different proportions of the reserve.",
        "Weight each habitat mean by its share of the 100 quadrats.",
        "Calculate (80 * 10 + 20 * 30) / (80 + 20)."),
      14, "The reserve gate opens. You accounted for the unequal habitat sizes."
    ),
    .en_lesson(
      "Experimental design and pseudoreplication", 20:28, "The Aquarium Illusion",
      "Identify experimental units and avoid counting subsamples as treatment replicates.",
      "The teacher has filled six virtual tanks with fish and inflated the replication counter.",
      "Three independent tanks receive a contaminant and three independent tanks receive a control. Treatment is assigned to each whole tank. Growth is measured in 5 fish per tank. Create tank IDs with rep(1:6, each = 5). How many independent treatment replicates are there in total across both treatments? Submit that number.",
      c("The experimental unit is the unit to which treatment is independently assigned.",
        "Fish in the same tank are subsamples; more fish do not create more independent tanks.",
        "Calculate length(unique(rep(1:6, each = 5)))."),
      6, "The false counter disappears. Six tanks give six independent treatment replicates.", 0L
    ),
    .en_lesson(
      "Exploratory graphics and transformations", c(30:32, 55:57), "The Standardisation Mirror",
      "Centre and scale measurements using the sample standard deviation.",
      "A mirror stretches ecological measurements into incompatible scales. The teacher has hidden the key in a standardised value.",
      "Five plant heights in cm are c(2,4,6,8,10). Make a boxplot to inspect them, then centre and scale them by subtracting their mean and dividing by their sample standard deviation. Submit the standardised value of the final height (10 cm), rounded to two decimal places.",
      c("A standardised value describes how many sample standard deviations a value is from the sample mean.",
        "Use scale(x), or (x - mean(x)) / sd(x). R's sd() uses the sample standard deviation.",
        "Set x <- c(2,4,6,8,10); boxplot(x); calculate round(as.numeric(scale(x))[5], 2)."),
      1.26, "The mirror settles. Centring and scaling made the measurements comparable.", 2L
    ),
    .en_lesson(
      "Hypothesis testing and p-values", c(14:16, 26L, 34L), "The Sign Test Lock",
      "Calculate an exact two-sided binomial p-value under a stated null hypothesis.",
      "Eight independent nest pairs wait beside a lock labelled H0. The teacher asks how surprising their signs are under no preference.",
      "In 8 independent nest pairs, species A has more chicks than species B in 7 pairs and fewer in 1; there are no ties. Under H0 either sign has probability 0.5. Run an exact two-sided binomial sign test. Submit its p-value rounded to four decimal places. Use alpha = 0.05 to consider the decision.",
      c("The null distribution for the number of positive signs is Binomial(8, 0.5). Include outcomes at least as extreme in either direction.",
        "binom.test() performs the exact test; its result has a p.value component.",
        "Calculate round(binom.test(7, 8, p = 0.5, alternative = 'two.sided')$p.value, 4)."),
      0.0703, "The lock opens. At alpha = 0.05 you do not reject H0; this does not establish that H0 is true.", 4L
    ),
    .en_lesson(
      "Assumptions and the one-sample t-test", c(11:15, 49:54), "The Reference Growth Chamber",
      "Compute a one-sample t statistic while recognizing independence and Normality assumptions.",
      "The teacher claims that population mean growth in the virtual greenhouse is 5 cm. A sample is your way to challenge the claim.",
      "Growth measurements in cm from 5 independent plants are c(4,5,6,7,8). For this exercise, assume a Normal parent population. Test H0: mean growth = 5 against a two-sided alternative. Submit the t statistic rounded to three decimal places, rather than the p-value.",
      c("The t statistic is (sample mean - null mean) / standard error of the mean.",
        "t.test(x, mu = 5) returns both statistic and p.value. Inspect the component requested by the lock.",
        "Calculate round(unname(t.test(c(4,5,6,7,8), mu = 5)$statistic), 3)."),
      1.414, "The chamber opens. The statistic measures departure from the null on a standard-error scale.", 3L
    ),
    .en_lesson(
      "One- and two-sample tests: signed ranks", 8:16, "The Ranked Shells",
      "Calculate the positive-rank sum in a one-sample Wilcoxon signed-rank test.",
      "Eight virtual shells surround a reference mark at 2 cm. The lock responds to ranks, rather than raw differences.",
      "Shell measurements in cm are c(2.2,2.8,1.1,4.3,2.5,5.6,0.3,1.9). For a Wilcoxon signed-rank test about location 2 cm, subtract 2, rank the absolute differences, and add the ranks for positive differences. Submit T+, which R labels V. Assume independent observations and a continuous distribution symmetric about its location under H0.",
      c("Keep the sign of each difference, but rank its absolute size from smallest to largest.",
        "Use rank(abs(d)) and select ranks for d > 0. There are no zero differences or tied absolute differences here.",
        "Set x <- c(2.2,2.8,1.1,4.3,2.5,5.6,0.3,1.9); d <- x - 2; calculate sum(rank(abs(d))[d > 0])."),
      24, "The shells sort themselves. Signed ranks retained direction while replacing magnitudes.", 0L
    ),
    .en_lesson(
      "Paired tests and one-way ANOVA", 31:46, "The Three Meadows",
      "Fit a one-way ANOVA and extract the between-group F statistic.",
      "The teacher offers three meadow doors. Comparing every pair separately would multiply your chances of a false alarm.",
      "Counts from independent equal-area quadrats are meadow A: c(2,3,4), B: c(5,6,7), C: c(8,9,10). For this exercise, assume independent Normal errors with equal variance across meadows. Fit a one-way ANOVA to test whether all three population means are equal. Submit the F statistic for meadow, rounded to two decimal places.",
      c("ANOVA compares variation between group means with variation within groups.",
        "Create a response vector and a factor identifying each meadow, then use aov(count ~ meadow).",
        "Set count <- c(2,3,4,5,6,7,8,9,10); meadow <- factor(rep(c('A','B','C'), each=3)); calculate summary(aov(count ~ meadow))[[1]][['F value']][1]."),
      27, "The meadow doors align. The omnibus test asks whether at least one population mean differs.", 2L
    ),
    .en_lesson(
      "Multiple comparisons and factorial ANOVA", 26:43, "The Interaction Trap",
      "Recognize a factorial interaction through a difference of treatment effects.",
      "Two levers control shade and fertiliser. The teacher insists fertiliser has the same effect in sun and shade.",
      "Mean plant growth in cm is sun without fertiliser: 4, sun with fertiliser: 10, shade without fertiliser: 3, shade with fertiliser: 5. Calculate the fertiliser effect in sun minus its effect in shade. Submit this interaction contrast in cm. These four means alone do not provide an interaction significance test.",
      c("An interaction means the effect of one factor depends on the level of another.",
        "Subtract the unfertilised mean from the fertilised mean within each light condition.",
        "Calculate (10 - 4) - (5 - 3)."),
      4, "The levers release. Fertiliser adds 6 cm in sun and 2 cm in shade: a contrast of 4 cm."
    ),
    .en_lesson(
      "Blocks, repeated measures, and nested designs", 15:20, "The Blocked Greenhouse",
      "Account for matched blocks by analysing differences within each block.",
      "Four greenhouse benches have different baseline conditions. Each contains a randomly assigned control pot and a treated pot.",
      "Control growth in cm on benches 1 to 4 is c(10,20,30,40). Treatment growth on those same benches, in the same order, is c(12,23,31,44). Compute treatment minus control within each bench, then submit the mean difference in cm. Benches are independent blocks; preserve their pairing.",
      c("Comparing within a bench removes its shared baseline from the difference.",
        "Subtract the two vectors element by element, keeping bench order.",
        "Calculate mean(c(12,23,31,44) - c(10,20,30,40)). A paired t-test can assess this mean under suitable assumptions."),
      2.5, "The greenhouse opens. Your comparison respected the blocks."
    ),
    .en_lesson(
      "Simple and multiple linear regression", 18:27, "The Regression Staircase",
      "Fit a linear regression and interpret its slope in ecological units.",
      "A staircase rises with nutrient concentration. The teacher has erased the slope from its blueprint.",
      "Nutrient concentrations in mg/L are c(1,2,3,4,5), and algal biomass in g/m^2 is c(3,5,4,8,10), in matching order. Fit biomass as a linear function of nutrient concentration with an intercept. Submit the slope in biomass units per mg/L, rounded to two decimal places.",
      c("The slope describes the fitted change in biomass for a one-unit increase in nutrient concentration.",
        "Use lm(biomass ~ nutrient), then extract the nutrient coefficient rather than the intercept.",
        "Set nutrient <- c(1,2,3,4,5); biomass <- c(3,5,4,8,10); calculate unname(coef(lm(biomass ~ nutrient))['nutrient'])."),
      1.7, "The staircase takes shape. Your slope describes association; these data alone do not prove causation.", 2L
    ),
    .en_lesson(
      "Factors in regression and model diagnostics", 21:35, "The Residual Window",
      "Calculate residuals from a fitted model and identify the largest absolute residual.",
      "A window shows only the observations that the teacher's fitted line fails to explain.",
      "Set nutrient <- c(1,2,3,4,5) and biomass <- c(3,5,4,8,10), then fit biomass ~ nutrient. Plot residuals against fitted values and inspect a Normal Q-Q plot of the residuals. Submit the observation number (1 to 5 in the given order) with the largest absolute residual. This flags an observation to investigate, rather than a reason to delete it automatically.",
      c("A residual is observed biomass minus fitted biomass. Absolute size ignores its sign.",
        "Use residuals(model), abs(), and which.max(). Five observations offer limited evidence about assumptions.",
        "Set m <- lm(biomass ~ nutrient); plot(fitted(m), residuals(m)); qqnorm(residuals(m)); qqline(residuals(m)); calculate which.max(abs(residuals(m)))."),
      3, "The window clears around observation 3. Investigate the discrepancy before deciding how to handle it.", 0L
    ),
    .en_lesson(
      "GLMs, links, and model selection", c(21:30, 34L), "The Logistic Gate",
      "Transform a binomial GLM linear predictor into a probability on the response scale.",
      "The gate accepts probabilities, but the teacher has left its species-presence prediction on the logit scale.",
      "A fitted binomial GLM uses logit(p) = -2 + 0.5 * temperature, with temperature in degrees C. Calculate the predicted presence probability at 6 degrees C. Submit the probability rounded to four decimal places.",
      c("Compute the linear predictor first, then apply the inverse link to return to the probability scale.",
        "The inverse logit is 1 / (1 + exp(-eta)); R provides plogis(eta).",
        "Calculate round(plogis(-2 + 0.5 * 6), 4). With a fitted glm object, predict(..., type = 'response') performs this conversion."),
      0.7311, "The gate accepts a probability between 0 and 1. You returned to the response scale.", 4L
    ),
    .en_lesson(
      "Generalized additive models", 20:28, "The Curved Forest",
      "Recognize when a smooth ecological response calls for a GAM.",
      "The forest path bends into a hump. The teacher's straight ruler cannot follow it.",
      "For an illustrative Gaussian response, set temperature <- 0:10 and growth <- c(1,2,4,7,9,10,9,7,4,2,1). Plot growth against temperature. You want a regression with a smooth temperature effect. Which model class supplies that smooth: LM, GLM with a linear temperature term, or GAM? Submit its abbreviation as text.",
      c("Growth rises and then falls. A Gaussian GLM with identity link and a linear temperature term still fits a straight line.",
        "Generalized additive models can include smooth functions of predictors.",
        "Use plot(temperature, growth, type = 'b'). The class is GAM; submit('GAM'). You can also explore the lecture's mgcv::gam() examples independently."),
      "gam", "The curved path opens. A GAM can fit a smooth effect; its complexity and diagnostics still need checking."
    ),
    .en_lesson(
      "Correlation and contingency tables", 30:36, "The Independence Table",
      "Compute an expected contingency-table count under independence.",
      "A virtual cabinet sorts animals by sex and colour. One expected count is missing from its independence model.",
      "Observed counts have rows male, female and columns brown, black, white: male = c(10,23,52); female = c(31,25,19). Enter them as a 2-by-3 matrix. Under independence of sex and colour, what is the expected count of brown males? Submit the expected count rounded to two decimal places.",
      c("Under independence, expected cell count = row total * column total / grand total.",
        "Use rowSums(), colSums(), and sum(). An expected count need not be an integer.",
        "Set tab <- rbind(male=c(10,23,52), female=c(31,25,19)); calculate round(rowSums(tab)[1] * colSums(tab)[1] / sum(tab), 2)."),
      21.78, "The cabinet opens. Expected counts describe the null model; the observed brown-male count is still 10.", 2L
    ),
    .en_lesson(
      "Log-linear models and maximum likelihood", 26:29, "The Likelihood Nest",
      "Find a Bernoulli maximum-likelihood estimate using a grid search.",
      "The teacher has hidden the next key at the peak of a likelihood curve for five nests.",
      "Independent nests have egg-presence records c(1,0,1,0,0), with common presence probability theta. The likelihood for this observed sequence is theta^2 * (1 - theta)^3. Evaluate it for theta from 0 to 1 in steps of 0.01 and plot the curve. Submit the theta that maximises the likelihood. A likelihood is not a posterior probability of theta.",
      c("Keep the observed data fixed and vary the parameter. Find the parameter value with the greatest likelihood.",
        "Use seq(0, 1, by = 0.01) and which.max() to find the grid maximum.",
        "Set theta <- seq(0,1,by=0.01); likelihood <- theta^2 * (1-theta)^3; plot(theta, likelihood, type='l'); calculate theta[which.max(likelihood)]."),
      0.4, "The key appears at theta = 0.4. Maximum likelihood chooses the parameter that best supports the observed data."
    ),
    .en_lesson(
      "Multivariate data and classification", 21:26, "The Community Matrix",
      "Organize sites as rows and species as columns, then summarize each species.",
      "Three virtual ponds contain two species. The teacher has scrambled the distinction between rows and columns.",
      "Rows are ponds A, B, C; columns are frog and newt counts. The rows are c(2,8), c(4,6), c(6,4). Build a community matrix in that orientation and calculate mean abundance per species across ponds. Submit the mean newt count per pond.",
      c("One row is one pond; one column is one species. Summaries across ponds operate down columns.",
        "Use rbind() to combine rows and colMeans() to calculate species means.",
        "Set community <- rbind(A=c(frog=2,newt=8), B=c(frog=4,newt=6), C=c(frog=6,newt=4)); calculate unname(colMeans(community)['newt'])."),
      6, "The ponds return to their rows. Your community matrix now supports multivariate exploration."
    ),
    .en_lesson(
      "Distances and hierarchical clustering", c(24L, 29L, 30L), "The Shared Species Lock",
      "Calculate Jaccard dissimilarity for presence-absence data while excluding joint absences.",
      "Two islands share some species and lack others. The teacher tries to make their shared absences look like ecological similarity.",
      "Presence-absence vectors for species in the same order are island A: c(1,1,0,0,1), B: c(1,0,1,0,1). Calculate Jaccard dissimilarity: 1 minus the number of jointly present species divided by the number present on at least one island. Submit the dissimilarity, rather than the similarity.",
      c("A species absent from both islands contributes neither to the intersection nor to the union.",
        "Use logical & for presence on both islands and | for presence on either island.",
        "Set a <- c(1,1,0,0,1); b <- c(1,0,1,0,1); calculate 1 - sum(a == 1 & b == 1) / sum(a == 1 | b == 1)."),
      0.5, "The island lock opens. Shared absences do not increase Jaccard similarity."
    ),
    .en_lesson(
      "Non-hierarchical clustering and ordination", 31:34, "The Two Shoals",
      "Run k-means with explicit initial centres and interpret a centre independently of its label.",
      "Four virtual sampling sites form two shoals. Their group labels change whenever the teacher turns the map around.",
      "Two species have counts at sites A: c(1,1), B: c(1,2), C: c(9,9), D: c(9,10). Build a matrix with those rows and fit k-means using A and C as the two initial centres, with no scaling. Submit the first-species coordinate of the cluster centre with the larger first-species coordinate. This is independent of whether that cluster is labelled 1 or 2.",
      c("A cluster centre is the mean of its member observations in each variable.",
        "Use kmeans(x, centers = x[c(1,3), ]) to make initialisation explicit; inspect centers.",
        "Set x <- rbind(A=c(1,1), B=c(1,2), C=c(9,9), D=c(9,10)); km <- kmeans(x, centers=x[c(1,3), ]); calculate max(km$centers[,1])."),
      9, "The shoals separate. You interpreted the centre rather than an arbitrary cluster label."
    ),
    .en_lesson(
      "PCA and other ordination methods", c(13:20, 30L), "The Final Principal Door",
      "Fit a PCA and calculate the proportion of variance explained by its first component.",
      "The final door projects a community onto fewer dimensions. The teacher will release you once you account for the information on its first axis.",
      "A two-species community matrix has site rows c(1,2), c(2,1), c(3,4), c(4,3). Both species use the same abundance units. Fit a PCA after centring each column, without scaling to unit variance. Plot component variances or inspect the PCA summary. Submit the percentage of total variance explained by PC1, rounded to one decimal place.",
      c("Divide the first component's variance by the sum of all component variances.",
        "Use prcomp(x, center = TRUE, scale. = FALSE). Square sdev to obtain component variances.",
        "Set x <- rbind(c(1,2),c(2,1),c(3,4),c(4,3)); pca <- prcomp(x, center=TRUE, scale.=FALSE); v <- pca$sdev^2; plot(v, type='b'); calculate round(100 * v[1] / sum(v), 1)."),
      80, "The final virtual door opens. PC1 retains 80% of the variance; the remaining 20% is on PC2. You can escapeR!", 1L
    )
  )
}
