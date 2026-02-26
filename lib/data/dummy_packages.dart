import '../models/tour_package.dart';

final List<TourPackage> dummyPackages = [
  TourPackage(
    id: 'premium-1',
    title: "Maldives Luxury Resort",
    location: "South Ari Atoll, Maldives",
    duration: "5 Days - 4 Nights",
    imageUrl:
        "https://images.unsplash.com/photo-1514282401047-d79a71a590e8?auto=format&fit=crop&q=80&w=800",
    description:
        "Experience the ultimate overwater villa luxury in the heart of the Indian Ocean.",
    highlights: ["Private Water Villa", "Scuba Diving", "Sunset Cruise"],
    itinerary: [
      "Check-in at Male and speedboat transfer.",
      "Day at leisure exploring the house reef.",
      "Underwater dining experience.",
      "Spa and wellness retreat.",
      "Check-out and transfer back.",
    ],
    price: 8500.0,
    rating: 4.9,
  ),
  TourPackage(
    id: 'premium-2',
    title: "Swiss Alps Adventure",
    location: "Zermatt, Switzerland",
    duration: "6 Days - 5 Nights",
    imageUrl:
        "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&q=80&w=800",
    description:
        "Skiing, scenic train rides, and breathtaking mountain views near the Matterhorn.",
    highlights: ["Glacier Express", "Matterhorn Views", "Skiing Lessons"],
    itinerary: [
      "Arrival in Zurich and train to Zermatt.",
      "Gornergrat Railway excursion.",
      "Skiing or trekking day.",
      "Visit to the Glacier Palace.",
      "Leisure day in Zermatt village.",
      "Return to Zurich.",
    ],
    price: 14500.0,
    rating: 4.8,
  ),
  TourPackage(
    id: 'premium-3',
    title: "Santorini Sunset Tour",
    location: "Oia, Santorini, Greece",
    duration: "4 Days - 3 Nights",
    imageUrl:
        "https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?auto=format&fit=crop&q=80&w=800",
    description: "Iconic blue-domed churches and world-famous golden sunsets.",
    highlights: ["Oia Sunset", "Wine Tasting", "Boat Tour"],
    itinerary: [
      "Arrival at Thira and transfer to Cliffside hotel.",
      "Guided tour of Akrotiri ruins.",
      "Catamaran cruise around the caldera.",
      "Winery tour at sunset.",
      "Departure.",
    ],
    price: 9800.0,
    rating: 4.9,
  ),
  TourPackage(
    id: 'premium-4',
    title: "Bali Tropical Escapade",
    location: "Ubud & Seminyak, Indonesia",
    duration: "7 Days - 6 Nights",
    imageUrl:
        "https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80&w=800",
    description:
        "Lush rice terraces, ancient temples, and pristine beaches of the Island of the Gods.",
    highlights: ["Tegallalang Rice Terrace", "Uluwatu Temple", "Luxury Villas"],
    itinerary: [
      "Arrival and transfer to Ubud.",
      "Sacred Monkey Forest exploration.",
      "Balinese cooking class.",
      "Transfer to Seminyak.",
      "Beach club day.",
      "Surfing lessons.",
      "Departure.",
    ],
    price: 6500.0,
    rating: 4.7,
  ),
];
