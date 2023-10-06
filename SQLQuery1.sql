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

-- highest infection rate
select location,population, max(total_cases), max(total_cases/population)*100 as infection_per
from project_2..CovidDeaths$
group by location,population
order by infection_per desc

--highest death count by country
select location, max(cast(total_deaths as int)) as death_count
from project_2..CovidDeaths$
where continent is not null
group by location
order by death_count desc

--highest deatch count by continent 
select location, max(cast(total_deaths as int)) as death_count
from project_2..CovidDeaths$
where continent is null and location<> 'World'
group by location
order by death_count desc

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

