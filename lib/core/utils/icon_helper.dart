import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class IconHelper {
  /// Chuyển đổi IconData thành tên string
  static String iconDataToString(IconData icon) {
    if (icon == FontAwesomeIcons.utensils)
      return 'utensils';
    else if (icon == FontAwesomeIcons.bus)
      return 'bus';
    else if (icon == FontAwesomeIcons.cartShopping)
      return 'cartShopping';
    else if (icon == FontAwesomeIcons.user)
      return 'user';
    else if (icon == FontAwesomeIcons.laptop)
      return 'laptop';
    else if (icon == FontAwesomeIcons.film)
      return 'film';
    else if (icon == FontAwesomeIcons.plane)
      return 'plane';
    else if (icon == FontAwesomeIcons.chartBar)
      return 'chartBar';
    else if (icon == FontAwesomeIcons.creditCard)
      return 'creditCard';
    else if (icon == FontAwesomeIcons.bolt)
      return 'bolt';
    else if (icon == FontAwesomeIcons.receipt)
      return 'receipt';
    else if (icon == FontAwesomeIcons.car)
      return 'car';
    else if (icon == FontAwesomeIcons.rightLeft)
      return 'rightLeft';
    else if (icon == FontAwesomeIcons.moneyBill1)
      return 'moneyBill1';
    else if (icon == FontAwesomeIcons.moneyBill)
      return 'moneyBill';
    else if (icon == FontAwesomeIcons.shirt)
      return 'shirt';
    else if (icon == FontAwesomeIcons.faceSmile)
      return 'faceSmile';
    else if (icon == FontAwesomeIcons.graduationCap)
      return 'graduationCap';
    else if (icon == FontAwesomeIcons.heartPulse)
      return 'heartPulse';
    else if (icon == FontAwesomeIcons.house)
      return 'house';
    else if (icon == FontAwesomeIcons.laptopCode)
      return 'laptopCode';
    else if (icon == FontAwesomeIcons.briefcase)
      return 'briefcase';
    else if (icon == FontAwesomeIcons.gift)
      return 'gift';
    else if (icon == FontAwesomeIcons.football)
      return 'football';
    else if (icon == FontAwesomeIcons.music)
      return 'music';
    else if (icon == FontAwesomeIcons.book)
      return 'book';
    else if (icon == FontAwesomeIcons.paw)
      return 'paw';
    else if (icon == FontAwesomeIcons.users)
      return 'users';
    else if (icon == FontAwesomeIcons.calendarDays)
      return 'calendarDays';
    else if (icon == FontAwesomeIcons.cakeCandles)
      return 'cakeCandles';
    else if (icon == FontAwesomeIcons.baby)
      return 'baby';
    else if (icon == FontAwesomeIcons.dumbbell)
      return 'dumbbell';
    else if (icon == FontAwesomeIcons.seedling)
      return 'seedling';
    else if (icon == FontAwesomeIcons.palette)
      return 'palette';
    else if (icon == FontAwesomeIcons.chartPie)
      return 'chartPie';
    else if (icon == FontAwesomeIcons.camera)
      return 'camera';
    else if (icon == FontAwesomeIcons.gamepad)
      return 'gamepad';
    else
      return 'ellipsis';
  }

  /// Chuyển đổi tên string thành IconData
  static IconData stringToIconData(String iconName) {
    switch (iconName) {
      case 'utensils':
        return FontAwesomeIcons.utensils;
      case 'bus':
        return FontAwesomeIcons.bus;
      case 'cartShopping':
        return FontAwesomeIcons.cartShopping;
      case 'user':
        return FontAwesomeIcons.user;
      case 'laptop':
        return FontAwesomeIcons.laptop;
      case 'film':
        return FontAwesomeIcons.film;
      case 'plane':
        return FontAwesomeIcons.plane;
      case 'chartBar':
        return FontAwesomeIcons.chartBar;
      case 'creditCard':
        return FontAwesomeIcons.creditCard;
      case 'bolt':
        return FontAwesomeIcons.bolt;
      case 'receipt':
        return FontAwesomeIcons.receipt;
      case 'car':
        return FontAwesomeIcons.car;
      case 'rightLeft':
        return FontAwesomeIcons.rightLeft;
      case 'moneyBill1':
        return FontAwesomeIcons.moneyBill1;
      case 'moneyBill':
        return FontAwesomeIcons.moneyBill;
      case 'shirt':
        return FontAwesomeIcons.shirt;
      case 'faceSmile':
        return FontAwesomeIcons.faceSmile;
      case 'graduationCap':
        return FontAwesomeIcons.graduationCap;
      case 'heartPulse':
        return FontAwesomeIcons.heartPulse;
      case 'house':
        return FontAwesomeIcons.house;
      case 'laptopCode':
        return FontAwesomeIcons.laptopCode;
      case 'briefcase':
        return FontAwesomeIcons.briefcase;
      case 'gift':
        return FontAwesomeIcons.gift;
      case 'football':
        return FontAwesomeIcons.football;
      case 'music':
        return FontAwesomeIcons.music;
      case 'book':
        return FontAwesomeIcons.book;
      case 'paw':
        return FontAwesomeIcons.paw;
      case 'users':
        return FontAwesomeIcons.users;
      case 'calendarDays':
        return FontAwesomeIcons.calendarDays;
      case 'cakeCandles':
        return FontAwesomeIcons.cakeCandles;
      case 'baby':
        return FontAwesomeIcons.baby;
      case 'dumbbell':
        return FontAwesomeIcons.dumbbell;
      case 'seedling':
        return FontAwesomeIcons.seedling;
      case 'palette':
        return FontAwesomeIcons.palette;
      case 'chartPie':
        return FontAwesomeIcons.chartPie;
      case 'camera':
        return FontAwesomeIcons.camera;
      case 'gamepad':
        return FontAwesomeIcons.gamepad;
      default:
        return FontAwesomeIcons.ellipsis;
    }
  }
}
