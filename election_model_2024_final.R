library(usmap)
library(tidyverse)



polls = read_csv("C:/Users/ccwar/Downloads/president_polls (1).csv")
region_map = read_csv("C:/Users/ccwar/Documents/MSDS/Election Model Data/processed_data_sets/region_map.csv")


sub_polls = polls %>%
  filter(numeric_grade > 1 & hypothetical == FALSE & office_type == "U.S. President")%>%
  select(poll_id, pollster_id, display_name, numeric_grade, pollscore, state, created_at, party, candidate_name, pct)%>%
  mutate(state = as.factor(toupper(state)), created_at = as.Date(str_remove(created_at, " .*"), format = "%m/%d/%y"))

polls_uni = unique(polls$poll_id)

current_date = as.Date("2024-10-10")



hq_polls_summary = sub_polls %>%
  mutate(days_since_poll = as.numeric(difftime(current_date, created_at), units = "days"))%>%
  mutate(poll_weight = 0.5^(days_since_poll/28))%>%
  group_by(state, candidate_name) %>%
  summarize(avg_pct = weighted.mean(pct, poll_weight))

head_to_head = hq_polls_summary %>%
  filter(candidate_name %in% c("Kamala Harris", "Donald Trump"))%>%
  pivot_wider(names_from = candidate_name, values_from = avg_pct)

state_pred = left_join(region_map, head_to_head,  by = c("state" = "state"))%>%
  mutate(`Donald Trump`= ifelse(is.na(`Donald Trump`), REPUBLICAN, `Donald Trump`),
         `Kamala Harris` = ifelse(is.na(`Kamala Harris`), DEMOCRAT, `Kamala Harris`))%>%
  mutate(combined_vote_dem = (DEMOCRAT + `Kamala Harris`)/2,
         combined_vote_repub = (REPUBLICAN + `Donald Trump`)/2)%>%
  mutate(winner = ifelse(combined_vote_dem < combined_vote_repub, "Trump", "Harris"))


election_day = as.Date("2024-11-05")
current_day = Sys.Date()
till_elec = as.numeric(difftime(election_day, current_day))
days = 1:till_elec
for(i in days){
  test = state_pred %>%
    mutate(`Donald Trump` = `Donald Trump` + rnorm(1, mean = 0),
           `Kamala Harris` = `Kamala Harris` + rnorm(1, mean = 0),
           combined_vote_dem = (DEMOCRAT + `Kamala Harris`)/2,
           combined_vote_repub = (REPUBLICAN + `Donald Trump`)/2)%>%
    mutate(winner = ifelse(combined_vote_dem < combined_vote_repub, "Trump", "Harris"))

  winner = test %>%
    group_by(winner)%>%
    summarize(ECV = sum(Electoral_College_Votes))
  }



ec_votes = state_pred %>%
  group_by(winner)%>%
  summarize(total = sum(Electoral_College_Votes))

close_races = state_pred %>%
  filter(abs(`Donald Trump` - `Kamala Harris`) < 2)



