import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  List<Widget> items = [
    ItemsWishlist(
      image: "assets/itemsImage/item1.jpeg",
      nama: "Kemeja kotak putih",
      price: 140000,
    ),
    ItemsWishlist(
      image: "assets/itemsImage/item1.jpeg",
      nama: "Kemeja kotak putih",
      price: 110000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 19),
                child: Text(
                  "Wishlist",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 5,
                color: Color(0xffECEAF3),
                width: double.infinity,
              ),
              SizedBox(height: 15),
              for (int i = 0; i < items.length; i++) items[i],
            ],
          ),
        ),
      ],
    );
  }
}

class ItemsWishlist extends StatelessWidget {
  ItemsWishlist({
    Key? key,
    this.nama,
    this.image,
    this.price,
  }) : super(key: key);

  String? nama;
  int? price;
  String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 19),
      height: MediaQuery.of(context).size.height * 0.149,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      print("Show Item");
                    },
                    child: Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('${image}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            print("Show Item");
                          },
                          child: Text(
                            "${nama}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Rp${price}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Color(0xFF9C62FF),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            print("Add to Cart");
                          },
                          child: Container(
                            width: 90,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFF9C62FF),
                            ),
                            child: Center(
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  highlightColor: Colors.red,
                  onTap: () {},
                  child: Icon(
                    Icons.delete,
                    color: Color(0xFFC3C5CD),
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Color(0xFF635E72),
            height: 20,
          ),
        ],
      ),
    );
  }
}
