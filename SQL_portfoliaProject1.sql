select * from project..covidDeath
order by 3,4

select * from project..CovidVaccinations
order by 3,4

--selecting data that I am going to use

select location,date, total_cases,new_cases, total_deaths,population from project..covidDeath
order by 1,2

--Find death percentage in India (likelihood for dying if you have contracted covid in the India)

select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage from project..covidDeath
WHERE location = 'India'
order by 1,2

--percentage of population got covid

select location,date, total_cases, population, (total_cases/population)*100 as percentage_population_infected from project..covidDeath
order by 1,2

--country with highest infection rate compared to its population from highest to lowest
 
select location, max(total_cases)as HighestInfectionCount , population, max((total_cases/population))*100 as percentage_population_infected 
from project..covidDeath
group by location, population
order by percentage_population_infected desc

--country with highest death rate compared to its population from highest to lowest of each continent

select continent, max(cast(total_deaths as int))as HighestDeathCount 
from project..covidDeath
where continent is not null
group by continent
order by HighestDeathCount desc

--Finding total cases, total deaths and death percentage

select sum(total_cases) as Totalcases, sum(cast(total_deaths as int))as TotalDeaths, (sum(cast(total_deaths as int))/sum(total_cases))*100
as DeathPercentage
from project..covidDeath

--Looking at total population vs vaccination

select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location, dea.date) as cummilativePeopleVaccinated
from project..covidDeath dea
join project..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

--with CTE

with x (continent , location, date, population, new_vaccinations,cummilativePeopleVaccinated) as (
select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location, dea.date) as cummilativePeopleVaccinated
from project..covidDeath dea
join project..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *, (cummilativePeopleVaccinated/population)*100 as CummPercentPeopleVaccinated from x

--Temporary Table

drop table if exists #Percent_people_vaccinated
create table #Percent_people_vaccinated(
continent nvarchar(255), 
location nvarchar(255), 
date datetime,
population numeric, 
new_vaccinations numeric,
cummilativePeopleVaccinated numeric
)
Insert into #Percent_people_vaccinated
select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location, dea.date) as cummilativePeopleVaccinated
from project..covidDeath dea
join project..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null

select *, (cummilativePeopleVaccinated/population)*100 as CummPercentPeopleVaccinated from #Percent_people_vaccinated

--Creating view

create view  Percent_people_vaccinated as 
select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location, dea.date) as cummilativePeopleVaccinated
from project..covidDeath dea
join project..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

select * from Percent_people_vaccinated
















