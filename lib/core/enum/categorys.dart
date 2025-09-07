import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Categorys {
  food(
    name: 'Food',
    icon: FontAwesomeIcons.utensils,
    backgroundIcon: Colors.red,
  ),
  transport(
    name: 'Transport',
    icon: FontAwesomeIcons.bus,
    backgroundIcon: Colors.blue,
  ),
  shopping(
    name: 'Shopping',
    icon: FontAwesomeIcons.cartShopping,
    backgroundIcon: Colors.green,
  ),
  others(
    name: 'Others',
    icon: FontAwesomeIcons.ellipsis,
    backgroundIcon: Colors.yellow,
  ),
  personal(
    name: 'Personal',
    icon: FontAwesomeIcons.user,
    backgroundIcon: Colors.purple,
  ),
  online(
    name: 'Online',
    icon: FontAwesomeIcons.laptop,
    backgroundIcon: Colors.orange,
  ),
  entertainment(
    name: 'Entertainment',
    icon: FontAwesomeIcons.film,
    backgroundIcon: Colors.cyan,
  ),
  travel(
    name: 'Travel',
    icon: FontAwesomeIcons.plane,
    backgroundIcon: Colors.teal,
  ),
  investment(
    name: 'Investment',
    icon: FontAwesomeIcons.chartBar,
    backgroundIcon: Colors.pink,
  ),
  payment(
    name: 'Payment',
    icon: FontAwesomeIcons.creditCard,
    backgroundIcon: Colors.brown,
  ),
  quick(
    name: 'Quick',
    icon: FontAwesomeIcons.bolt,
    backgroundIcon: Colors.indigo,
  ),
  bills(
    name: 'Bills',
    icon: FontAwesomeIcons.receipt,
    backgroundIcon: Colors.amber,
  ),
  vehicle(
    name: 'Vehicle',
    icon: FontAwesomeIcons.car,
    backgroundIcon: Colors.deepPurple,
  ),
  xchange(
    name: 'Xchange',
    icon: FontAwesomeIcons.rightLeft,
    backgroundIcon: Colors.lightGreen,
  ),
  withdraw(
    name: 'Withdraw',
    icon: FontAwesomeIcons.moneyBill1,
    backgroundIcon: Colors.deepOrange,
  ),
  transfer(
    name: 'Transfer',
    icon: FontAwesomeIcons.rightLeft,
    backgroundIcon: Colors.lightBlue,
  ),
  fees(
    name: 'Fees',
    icon: FontAwesomeIcons.moneyBill,
    backgroundIcon: Colors.blueGrey,
  ),
  apparel(
    name: 'Apparel',
    icon: FontAwesomeIcons.shirt,
    backgroundIcon: Colors.redAccent,
  ),
  beauty(
    name: 'Beauty',
    icon: FontAwesomeIcons.faceSmile,
    backgroundIcon: Colors.greenAccent,
  ),
  education(
    name: 'Education',
    icon: FontAwesomeIcons.graduationCap,
    backgroundIcon: Colors.yellowAccent,
  ),
  health(
    name: 'Health',
    icon: FontAwesomeIcons.heartPulse,
    backgroundIcon: Colors.purpleAccent,
  ),
  home(
    name: 'Home',
    icon: FontAwesomeIcons.house,
    backgroundIcon: Colors.orangeAccent,
  ),
  technology(
    name: 'Technology',
    icon: FontAwesomeIcons.laptopCode,
    backgroundIcon: Colors.cyanAccent,
  ),
  work(
    name: 'Work',
    icon: FontAwesomeIcons.briefcase,
    backgroundIcon: Colors.tealAccent,
  ),
  gifts(
    name: 'Gifts',
    icon: FontAwesomeIcons.gift,
    backgroundIcon: Colors.pinkAccent,
  ),
  sports(
    name: 'Sports',
    icon: FontAwesomeIcons.football,
    backgroundIcon: Colors.brown,
  ),
  music(
    name: 'Music',
    icon: FontAwesomeIcons.music,
    backgroundIcon: Colors.indigoAccent,
  ),
  books(
    name: 'Books',
    icon: FontAwesomeIcons.book,
    backgroundIcon: Colors.amberAccent,
  ),
  pets(
    name: 'Pets',
    icon: FontAwesomeIcons.paw,
    backgroundIcon: Colors.deepPurpleAccent,
  ),
  social(
    name: 'Social',
    icon: FontAwesomeIcons.users,
    backgroundIcon: Colors.lightGreenAccent,
  ),
  events(
    name: 'Events',
    icon: FontAwesomeIcons.calendarDays,
    backgroundIcon: Colors.deepOrangeAccent,
  ),
  party(
    name: 'Party',
    icon: FontAwesomeIcons.cakeCandles,
    backgroundIcon: Colors.lightBlueAccent,
  ),
  baby(
    name: 'Baby',
    icon: FontAwesomeIcons.baby,
    backgroundIcon: Colors.blueGrey,
  ),
  fitness(
    name: 'Fitness',
    icon: FontAwesomeIcons.dumbbell,
    backgroundIcon: Colors.redAccent,
  ),
  gardening(
    name: 'Gardening',
    icon: FontAwesomeIcons.seedling,
    backgroundIcon: Colors.greenAccent,
  ),
  art(
    name: 'Art',
    icon: FontAwesomeIcons.palette,
    backgroundIcon: Colors.yellowAccent,
  ),
  finance(
    name: 'Finance',
    icon: FontAwesomeIcons.chartPie,
    backgroundIcon: Colors.purpleAccent,
  ),
  photography(
    name: 'Photography',
    icon: FontAwesomeIcons.camera,
    backgroundIcon: Colors.orangeAccent,
  ),
  gaming(
    name: 'Gaming',
    icon: FontAwesomeIcons.gamepad,
    backgroundIcon: Colors.cyanAccent,
  );

  final String name;
  final IconData icon;
  final Color backgroundIcon;

  const Categorys({
    required this.name,
    required this.icon,
    required this.backgroundIcon,
  });

  static Categorys fromIndex(int categoryIndex) {
    return Categorys.values.firstWhere(
      (category) => category.index == categoryIndex,
      orElse: () => Categorys.others,
    );
  }

  String getLocalizedName() {
    switch (this) {
      case Categorys.food:
        return 'category.food'.tr();
      case Categorys.transport:
        return 'category.transport'.tr();
      case Categorys.shopping:
        return 'category.shopping'.tr();
      case Categorys.others:
        return 'category.others'.tr();
      case Categorys.personal:
        return 'category.personal'.tr();
      case Categorys.online:
        return 'category.online'.tr();
      case Categorys.entertainment:
        return 'category.entertainment'.tr();
      case Categorys.travel:
        return 'category.travel'.tr();
      case Categorys.investment:
        return 'category.investment'.tr();
      case Categorys.payment:
        return 'category.payment'.tr();
      case Categorys.quick:
        return 'category.quick'.tr();
      case Categorys.bills:
        return 'category.bills'.tr();
      case Categorys.vehicle:
        return 'category.vehicle'.tr();
      case Categorys.xchange:
        return 'category.xchange'.tr();
      case Categorys.withdraw:
        return 'category.withdraw'.tr();
      case Categorys.transfer:
        return 'category.transfer'.tr();
      case Categorys.fees:
        return 'category.fees'.tr();
      case Categorys.apparel:
        return 'category.apparel'.tr();
      case Categorys.beauty:
        return 'category.beauty'.tr();
      case Categorys.education:
        return 'category.education'.tr();
      case Categorys.health:
        return 'category.health'.tr();
      case Categorys.home:
        return 'category.home'.tr();
      case Categorys.technology:
        return 'category.technology'.tr();
      case Categorys.work:
        return 'category.work'.tr();
      case Categorys.gifts:
        return 'category.gifts'.tr();
      case Categorys.sports:
        return 'category.sports'.tr();
      case Categorys.music:
        return 'category.music'.tr();
      case Categorys.books:
        return 'category.books'.tr();
      case Categorys.pets:
        return 'category.pets'.tr();
      case Categorys.social:
        return 'category.social'.tr();
      case Categorys.events:
        return 'category.events'.tr();
      case Categorys.party:
        return 'category.party'.tr();
      case Categorys.baby:
        return 'category.baby'.tr();
      case Categorys.fitness:
        return 'category.fitness'.tr();
      case Categorys.gardening:
        return 'category.gardening'.tr();
      case Categorys.art:
        return 'category.art'.tr();
      case Categorys.finance:
        return 'category.finance'.tr();
      case Categorys.photography:
        return 'category.photography'.tr();
      case Categorys.gaming:
        return 'category.gaming'.tr();
    }
  }
}

const List<Categorys> categorys = Categorys.values;
