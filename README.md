# SlimyCard - Animated Flutter Project

SlimyCard provides a beautiful slime-like animation of a Card that separates into two different Cards, one at the top and the another at bottom. It is possible to put any custom widget in these two separate cards.

![Banner Image](https://raw.githubusercontent.com/AkashDivya/SlimyCard-Animated-Flutter-Project/master/images/SlimyCard-Animated-Flutter-Project-by-Akash-Divya.png?token=ALFS7AZOORZPXP3GSVF4VHK5VIFEC)

# How to install this package

  - **1. Depend on it**

    Add this to your package's pubspec.yaml file:
    
    ```
    dependencies:
      slimy_card: ^1.0.0
    ```
    
  - **2. Install it**
    
    You can install packages from the command line:

    with Flutter:
    
    ```
    $ flutter pub get
    ```
    
    Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.
    
# How to use this package

  - **1. Import it**
  
    In your Dart code, import the package as mentioned below:
    
    ```
    import 'package:slimy_card/slimy_card.dart';
    ```
    
  - **2. Use It**
  
    Create a ListView, and in its children use SlimyCard()
    
    ```
    ListView(
      children: <Widget>[
        SlimyCard(),
      ],
    );
    ```
    
  - **3. Custimize It**
    
    You can customize SlimyCard as per need, by using the following parameters:
    
    ```
    ListView(
      children: <Widget>[
        SlimyCard(
          color: Colors.red,
          width: 200,
          topCardHeight: 400,
          bottomCardHeight: 200,
          borderRadius: 15,
          topCardWidget: myWidget01(),
          bottomCardWidget: myWidget02(),
        ),
      ],
    );
    ```
    **myWidget01** & **myWidget02** are your custom widget which you can display in Top Card & Bottom Card respectively.
    
    
