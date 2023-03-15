--select * from dbo.Covid_Deaths;

--select * from dbo.Covid_Vaccinations order by 3,4;

--select location, date, total_cases, total_deaths, population from 
--PortfolioProject.dbo.Covid_Deaths
--order by 1,2;


--Shows the Likelihood of dying if someone contracts to Covid

select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as Death_Percentage 
from PortfolioProject.dbo.Covid_Deaths 
where location = 'United States'
order by date;

--shows what percentage of population contracted covid 

select location, date, total_cases, population, (total_cases/Population) * 100 as Population_Percentage_Covid 
from PortfolioProject.dbo.Covid_Deaths 
where location = 'United States'
order by date;

--Looking at highest infection rate compared to the total population

select location, population, max(total_cases), max((total_cases/Population)) * 100 as percent_population_infected 
from PortfolioProject.dbo.Covid_Deaths 
group by location,population
--where location = 'United States'
order by percent_population_infected desc;


--showing countries with highest death count per population
select location, max(total_deaths) as total_death_count 
from PortfolioProject.dbo.Covid_Deaths 
where continent is not null
group by location
--where location = 'United States'
order by total_death_count desc;


--Breaking down the data by Continent
select continent, max(total_deaths) as total_death_count 
from PortfolioProject.dbo.Covid_Deaths 
where continent is not null
group by continent
--where location = 'United States'
order by total_death_count desc;

--Global numbers
--Total death  percentage globally
set arithabort off
set ansi_warnings off
select date, sum(new_cases) as global_new_cases, sum(new_deaths) as global_new_deaths, isnull((sum(new_deaths)/sum(new_cases)),0) * 100 as Global_Death_Percent
from PortfolioProject.dbo.Covid_Deaths
where continent is not null
group by date
order by date ;

--Total death percentage globally as one

select  sum(new_cases) as global_new_cases, sum(new_deaths) as global_new_deaths, isnull((sum(new_deaths)/sum(new_cases)),0) * 100 as Global_Death_Percent
from PortfolioProject.dbo.Covid_Deaths
where continent is not null;


-- Total Population vs vaccinated count

with popvsvac(continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
from PortfolioProject.dbo.Covid_Deaths dea
join PortfolioProject.dbo.Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
select *, (rolling_people_vaccinated/population) * 100 as vaccinated_percent
from popvsvac;


--Creating views to store data for visualizing them later
create view vaccinated_population_per as
with popvsvac(continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
from PortfolioProject.dbo.Covid_Deaths dea
join PortfolioProject.dbo.Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
select *, (rolling_people_vaccinated/population) * 100 as vaccinated_percent
from popvsvac;

select * from vaccinated_population_per;



