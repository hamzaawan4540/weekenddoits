import '../models/car.dart';

/// Demo data used only for seeding Firestore (URL-only, no Storage).
final List<Car> dummyCars = [
  Car(
    name: 'Sedan',
    imageUrl:
        'https://th.bing.com/th/id/OIP.8LLfcbss0TLEsBU6aMCbfAHaEK?cb=iwp2&rs=1&pid=ImgDetMain',
    pricePerDay: 2000,
    locations: ['New York', 'Los Angeles', 'Miami', 'Chicago'],
  ),
  Car(
    name: 'SUV',
    imageUrl:
        'https://inspirationseek.com/wp-content/uploads/2016/01/SUV-Cars_07.jpg',
    pricePerDay: 3000,
    locations: ['New York', 'Los Angeles'],
  ),
  Car(
    name: 'Hatchback',
    imageUrl:
        'https://th.bing.com/th/id/OIP.091ceIh0FZ1SUq9YCivABQHaEK?cb=iwp2&rs=1&pid=ImgDetMain',
    pricePerDay: 1800,
    locations: ['Miami', 'Chicago'],
  ),
  Car(
    name: 'Convertible',
    imageUrl:
        'https://www.topgear.com/sites/default/files/cars-car/carousel/2015/02/buyers_guide_-_bmw_6_convertible_2014_-_front_quarter.jpg?w=1784&h=1004',
    pricePerDay: 4000,
    locations: ['Los Angeles', 'Miami'],
  ),
];
