import 'package:flutter/material.dart';

import 'package:population_dapp/repository/contract_link.dart';
import 'package:provider/provider.dart';

class DisplayPopulation extends StatefulWidget {
  @override
  State<DisplayPopulation> createState() => _DisplayPopulationState();
}

class _DisplayPopulationState extends State<DisplayPopulation> {
  final _name = TextEditingController();
  final _population = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLink>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Population On Blockchain"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    children: [
                      TextField(
                        controller: _name,
                        decoration: InputDecoration(hintText: "Enter Name"),
                      ),
                      TextField(
                        controller: _population,
                        decoration:
                            InputDecoration(hintText: "Enter Population "),
                             
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          contractLink.addData(
                              _name.text,
                              BigInt.from(
                                  int.parse(_population.text))); Navigator.pop(context); 
                        },
                        child: Text("Set"))
                  ],
                );
              });
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      contractLink.countryName == ""
                          ? Icon(
                              Icons.error,
                              size: 100,
                            )
                          : Container(
                              width: 250,
                              height: 150,
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Country - ${contractLink.countryName}",
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Population - ${contractLink.currentPopulation}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ),
                      contractLink.countryName == "Unknown"
                          ? Text("")
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      dialog(context, "Increase");
                                    },
                                    icon:
                                        Icon(Icons.person_add_alt_1, size: 18),
                                    label: Text("Increase"),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (contractLink.currentPopulation !=
                                          "0") {
                                        dialog(context, "Decrease");
                                      }
                                    },
                                    icon: Icon(Icons.person_remove_alt_1,
                                        size: 18),
                                    label: Text("Decrease"),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  dialog(context, method) {
    final contractLink = Provider.of<ContractLink>(context, listen: false);
    TextEditingController countController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: method == "Increase"
                  ? Text("Increase Population")
                  : Text("Decrease Population"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Current Population is ${contractLink.currentPopulation}"),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: countController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: method == "Increase"
                            ? "Increase Population By ..."
                            : "Decrease Population By ...",
                      ),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                Row(
                  children: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: method == "Increase"
                          ? Text("Increase")
                          : Text("Decrease"),
                      onPressed: () {
                        method == "Increase"
                            ? contractLink.increasePopulation(
                                int.parse(countController.text))
                            : contractLink.decreasePopulation(
                                int.parse(countController.text));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ));
  }
}
