/// A string that describes a specific point of interest (POI) category.
public enum PoiCategory: String, Decodable, Sendable {
    /// An airport.
    case airport = "Airport"

    /// A specific gate at an airport.
    case airportGate = "AirportGate"

    /// A specific named terminal at an airport.
    case airportTerminal = "AirportTerminal"

    /// An amusement park.
    case amusementPark = "AmusementPark"

    /// A veterinary clinic.
    case animalService = "AnimalService"

    /// An aquarium
    case aquarium = "Aquarium"

    /// An automated teller machine.
    case atm = "ATM"

    /// An automotive repair business.
    case automotiveRepair = "AutomotiveRepair"

    /// A bakery.
    case bakery = "Bakery"

    /// A bank.
    case bank = "Bank"

    /// A baseball stadium.
    case baseball = "Baseball"

    /// A basketball arena.
    case basketball = "Basketball"

    /// A beach.
    case beach = "Beach"

    /// A beautician shop.
    case beauty = "Beauty"

    /// A bowling venue.
    case bowling = "Bowling"

    /// A brewery.
    case brewery = "Brewery"

    /// A cafe.
    case cafe = "Cafe"

    /// A campground.
    case campground = "Campground"

    /// A car rental location.
    case carRental = "CarRental"

    /// A castle.
    case castle = "Castle"

    /// A convention center.
    case conventionCenter = "ConventionCenter"

    /// A distillery.
    case distillery = "Distillery"

    /// An electric vehicle (EV) charger.
    case evCharger = "EVCharger"

    /// A fair ground.
    case fairground = "Fairground"

    /// A fire station.
    case fireStation = "FireStation"

    /// A fishing location.
    case fishing = "Fishing"

    /// A fitness center.
    case fitnessCenter = "FitnessCenter"

    /// A food market.
    case foodMarket = "FoodMarket"

    /// A fortress.
    case fortress = "Fortress"

    /// A gas station.
    case gasStation = "GasStation"

    /// A go-kart racing venue.
    case goKart = "GoKart"

    /// A golf course.
    case golf = "Golf"

    /// A hiking trail.
    case hiking = "Hiking"

    /// A hospital.
    case hospital = "Hospital"

    /// A hotel.
    case hotel = "Hotel"

    /// A kayaking location.
    case kayaking = "Kayaking"

    /// A landmark.
    case landmark = "Landmark"

    /// A laundry.
    case laundry = "Laundry"

    /// A library.
    case library = "Library"

    /// A public mailbox.
    case mailbox = "Mailbox"

    /// A marina.
    case marina = "Marina"

    /// A mini-golf venue.
    case miniGolf = "MiniGolf"

    /// A movie theater.
    case movieTheater = "MovieTheater"

    /// A museum.
    case museum = "Museum"

    /// A music performance venue.
    case musicVenue = "MusicVenue"

    /// A national monument.
    case nationalMonument = "NationalMonument"

    /// A national park.
    case nationalPark = "NationalPark"

    /// A night life venue.
    case nightlife = "Nightlife"

    /// A park.
    case park = "Park"

    /// A parking location for an automobile.
    case parking = "Parking"

    /// A pharmacy.
    case pharmacy = "Pharmacy"

    /// A planetarium.
    case planetarium = "Planetarium"

    /// A playground.
    case playground = "Playground"

    /// A police station.
    case police = "Police"

    /// A post office.
    case postOffice = "PostOffice"

    /// A public transportation station.
    case publicTransport = "PublicTransport"

    /// A religious site.
    case religiousSite = "ReligiousSite"

    /// A restaurant.
    case restaurant = "Restaurant"

    /// A restroom.
    case restroom = "Restroom"

    /// A rock climbing venue.
    case rockClimbing = "RockClimbing"

    /// A recreational vehicle (RV) park.
    case rvPark = "RVPark"

    /// A school.
    case school = "School"

    /// A skate park.
    case skatePark = "SkatePark"

    /// A skating venue.
    case skating = "Skating"

    /// A ski slope.
    case skiing = "Skiing"

    /// A soccer pitch.
    case soccer = "Soccer"

    /// A spa location.
    case spa = "Spa"

    /// A stadium.
    case stadium = "Stadium"

    /// A store.
    case store = "Store"

    /// A surfing location.
    case surfing = "Surfing"

    /// A swimming location.
    case swimming = "Swimming"

    /// A tennis court.
    case tennis = "Tennis"

    /// A theater.
    case theater = "Theater"

    /// A university.
    case university = "University"

    /// A volleyball court.
    case volleyball = "Volleyball"

    /// A winery.
    case winery = "Winery"

    /// A zoo.
    case zoo = "Zoo"
}
