select*
from project_2..CovidDeaths$
order by 3,4

select location,date, total_cases, new_cases, total_deaths, population
from project_2..CovidDeaths$
order by 1,2
--death percentage in USA
select location,date, total_cases, total_deaths, 1/(total_cases/total_deaths)*100 as Death_percentage
from project_2..CovidDeaths$
where location like '%states%'
order by 1,2 


--3
-- highest infection rate
select location,population, max(total_cases) as total_cases, max(total_cases/population)*100 as infection_per
from project_2..CovidDeaths$
group by location,population
order by infection_per desc

--4
-- highest infection rate with date
select location,population, date, max(total_cases) as total_cases, max(total_cases/population)*100 as infection_per
from project_2..CovidDeaths$
group by location,population, date
order by infection_per desc



--highest death count by country
select location, max(cast(total_deaths as int)) as death_count
from project_2..CovidDeaths$
where continent is not null
group by location
order by death_count desc

--2
--highest deatch count by continent 
SELECT location, MAX(CAST(total_deaths AS INT)) AS death_count
FROM project_2..CovidDeaths$
WHERE continent IS NULL
  AND location <> 'World'
  AND location <> 'European Union'
  AND location <> 'International'
GROUP BY location
ORDER BY death_count DESC;

--same thing twice/ continent wise death
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From project_2..CovidDeaths$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--by date
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From project_2..CovidDeaths$
--Where location like '%states%'
where continent is not null 
Group By date
order by 1 ,2 asc

--total death in the world
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From project_2..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1 ,2 asc



--rolling sum of vaccinated people

drop table if exists #percetnpeoplevaccinated

create table #percetnpeoplevaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #percetnpeoplevaccinated



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From project_2..CovidDeaths$ dea
Join project_2..Vaccine$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select*, (RollingPeopleVaccinated/Population)*100 as Percentage_of_total_vaccination
from #percetnpeoplevaccinated


--creating the view for cisualization purpose 
create view percetnpeoplevaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From project_2..CovidDeaths$ dea
Join project_2..Vaccine$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
