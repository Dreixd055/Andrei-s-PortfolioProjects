Select *
from PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

Select *
from PortfolioProject..CovidVaccinations$
order by 3,4
--Select the data that we are going to be using

Select Location, date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
where continent is not null
and total_deaths is not null
order by 1,2

--Looking at the total cases vs total deaths
--Shows likelihood of dying if you contract covid in your country
Select Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2

--Looking at the total cases vs the population
--Shows what percentage of the population got covid
Select Location, date,total_cases,population,(total_cases/population)*100 as CasePercentage
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
order by 1,2

--Looking at countries with highest infection rate compared to population

Select Location,MAX(total_cases),population as highestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by population,location
order by PercentPopulationInfected desc

-- Show countries with highest death count per Population

select location, MAX(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

-- Breaking it down by Continent 

--Showing continents with the highest death counts
select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Numbers

select date, SUM(new_cases), SUM(cast(new_deaths as int)), sum (cast(new_deaths as int))/SUM(new_cases)*100
as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
		and dea.date = vac.date
		where dea.continent is not null
		order by 2,3
	