// homepage.dart
import 'package:flutter/material.dart';
import 'PdfService.dart'; // Import the PDF service
import 'package:gas_electric_invoice/models/BillData';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _clear(); // Load default values
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController lastIndexCtrl = TextEditingController();
  final TextEditingController currentIndexCtrl = TextEditingController();
  final TextEditingController redevanceFixCtrl = TextEditingController();
  final TextEditingController droitFixCtrl = TextEditingController();
  final TextEditingController taxHabitationCtrl = TextEditingController();
  final TextEditingController timbreCtrl = TextEditingController();

  // New controllers for Gaz section
  final TextEditingController lastIndexGazCtrl = TextEditingController();
  final TextEditingController currentIndexGazCtrl = TextEditingController();

  String? selectedRegion = "north";
  double? t1ElectrityHT;
  double? t2ElectrityHT;
  double? t1GazHT;
  double? t2GazHT;
  double? totalPrice;
  double contribution = 0;
  double priceE = 0;
  double priceG = 0;
  double consommationE = 0;
  double consommationG = 0;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double lastIndex = double.parse(lastIndexCtrl.text); // for electricity
      double currentIndex = double.parse(currentIndexCtrl.text); //for electricity
      double redevance = double.parse(redevanceFixCtrl.text);
      double droit = double.parse(droitFixCtrl.text);
      double tax = double.parse(taxHabitationCtrl.text);
      double timbre = double.parse(timbreCtrl.text);
      // Gaz values
      double lastIndexGaz = double.parse(lastIndexGazCtrl.text);
      double currentIndexGaz = double.parse(currentIndexGazCtrl.text);

      //---------------------------
      double dif = currentIndex - lastIndex; //for electricity

      List<double> prices = [1.7787, 4.1789, 4.8120, 5.4796];
      List<double> tranche = [0, 0, 0, 0];

      if (dif >= 1000) {
        tranche[0] = 125;
        tranche[1] = 125;
        tranche[2] = 750;
        tranche[3] = dif - 1000;
      } else if (dif >= 250 && dif < 1000) {
        tranche[0] = 125;
        tranche[1] = 125;
        tranche[2] = dif - 250;
        tranche[3] = 0;
      } else if (dif >= 125 && dif < 250) {
        tranche[0] = 125;
        tranche[1] = dif - 125;
        tranche[2] = 0;
        tranche[3] = 0;
      } else {
        tranche[0] = dif;
        tranche[1] = 0;
        tranche[2] = 0;
        tranche[3] = 0;
      }

      double t1 = tranche[0] * prices[0] + tranche[1] * prices[1];
      double t2 = tranche[2] * prices[2] + tranche[3] * prices[3];

      double difGaz = (currentIndexGaz - lastIndexGaz) * 9.4; // for gaz

      List<double> pricesGaz = [0.1682, 0.3245, 0.4025, 0.4599];
      List<double> trancheGaz = [0, 0, 0, 0];

      if (difGaz >= 7500) {
        trancheGaz[0] = 1125;
        trancheGaz[1] = 1375;
        trancheGaz[2] = 5000;
        trancheGaz[3] = difGaz - 7500;
      } else if (difGaz >= 2500 && difGaz < 7500) {
        trancheGaz[0] = 1125;
        trancheGaz[1] = 1375;
        trancheGaz[2] = difGaz - 2500;
        trancheGaz[3] = 0;
      } else if (difGaz >= 1125 && difGaz < 2500) {
        trancheGaz[0] = 1125;
        trancheGaz[1] = difGaz - 1125;
        trancheGaz[2] = 0;
        trancheGaz[3] = 0;
      } else {
        trancheGaz[0] = difGaz;
        trancheGaz[1] = 0;
        trancheGaz[2] = 0;
        trancheGaz[3] = 0;
      }

      double t1Gaz = trancheGaz[0] * pricesGaz[0] + trancheGaz[1] * pricesGaz[1];
      double t2Gaz = trancheGaz[2] * pricesGaz[2] + trancheGaz[3] * pricesGaz[3];

      //----------------------------
      if (selectedRegion == "sud") {
        contribution = 0.6445;
      } else {
        contribution = 0;
      }

      setState(() {
        t1ElectrityHT = t1;
        t2ElectrityHT = t2;
        consommationE = dif;
        priceE = t1 + t2;

        t1GazHT = t1Gaz;
        t2GazHT = t2Gaz;
        consommationG = difGaz;
        priceG = t1Gaz + t2Gaz;

        contribution = (t1 + t2 + t1Gaz + t2Gaz + redevance) * contribution;
        totalPrice = (t1 +
            t2 +
            t1Gaz +
            t2Gaz +
            (t1 + redevance + t1Gaz) * 0.09 +
            (t2 + t2Gaz) * 0.19 +
            redevance +
            droit +
            tax -
            contribution +
            timbre);
      });
    }
  }

  void _clear() {
    setState(() {
      lastIndexCtrl.clear();
      currentIndexCtrl.clear();

      redevanceFixCtrl.text = "164.16";
      droitFixCtrl.text = "200";
      taxHabitationCtrl.text = "150";
      lastIndexGazCtrl.clear();
      currentIndexGazCtrl.clear();
      //timbreCtrl.clear();// to clear the field
      timbreCtrl.text = "58";
      selectedRegion = "north"; // reset to default
      totalPrice = null;
    });
  }

 Future<void> _generatePDF() async {
    // Create BillData object with all the necessary information
    final billData = BillData(
      selectedRegion: selectedRegion!,
      lastIndex: lastIndexCtrl.text,
      currentIndex: currentIndexCtrl.text,
      redevanceFix: redevanceFixCtrl.text,
      droitFix: droitFixCtrl.text,
      taxHabitation: taxHabitationCtrl.text,
      timbre: timbreCtrl.text,
      lastIndexGaz: lastIndexGazCtrl.text,
      currentIndexGaz: currentIndexGazCtrl.text,
      t1ElectrityHT: t1ElectrityHT!,
      t2ElectrityHT: t2ElectrityHT!,
      t1GazHT: t1GazHT!,
      t2GazHT: t2GazHT!,
      consommationE: consommationE,
      consommationG: consommationG,
      priceE: priceE,
      priceG: priceG,
      contribution: contribution,
      totalPrice: totalPrice!,
    );

    // Call the PDF service
    await PDFService.generateBillPDF(billData);
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Entrez  $label";
        if (double.tryParse(value) == null) return "Entrez  un nombre valide";
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facture d'électricité et de gaz"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("calcule de l'électricité",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 5,
                    children: [
                      _buildNumberField("Dernier indice éléctricité", lastIndexCtrl),
                      _buildNumberField("Actuelle indice éléctricité", currentIndexCtrl),
                      _buildNumberField("Redevances Fixes HT", redevanceFixCtrl),
                      _buildNumberField("Droit Fix sur consommation", droitFixCtrl),
                      _buildNumberField("Tax d'habitation", taxHabitationCtrl),
                      _buildNumberField("Timbre", timbreCtrl),
                    ],
                  ),
                  Text("Calcule de Gaz",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 5,
                    children: [
                      _buildNumberField("Dernier indice gaz", lastIndexGazCtrl),
                      _buildNumberField("Actuelle indice gaz", currentIndexGazCtrl),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("nord ou du sud de l'algérie?"),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                title: const Text("Nord"),
                                value: "north",
                                groupValue: selectedRegion,
                                onChanged: (value) {
                                  setState(() {
                                    selectedRegion = value.toString();
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: const Text("Sud"),
                                value: "sud",
                                groupValue: selectedRegion,
                                onChanged: (value) {
                                  setState(() {
                                    selectedRegion = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.calculate),
                        label: const Text("Soumettre"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton.icon(
                        onPressed: _clear,
                        icon: const Icon(Icons.clear),
                        label: const Text("claire"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (totalPrice != null)
                    Card(
                      color: Colors.blue.shade50,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text("Résultats",
                                style: Theme.of(context).textTheme.titleLarge),
                            const Divider(),
                            Text("---- éléctricité ---- "),
                            Text("montant HT 9% = ${t1ElectrityHT!.toStringAsFixed(2)}"),
                            Text("montant HT 19% = ${t2ElectrityHT!.toStringAsFixed(2)}"),
                            Text("consommation = ${consommationE.toStringAsFixed(2)} Kwh"),
                            Text("montant HT éléctricité = ${priceE.toStringAsFixed(2)}"),
                            Text("---- gaz ---- "),
                            Text("montant HT 9% = ${t1GazHT!.toStringAsFixed(2)}"),
                            Text("montant HT 19% = ${t2GazHT!.toStringAsFixed(2)}"),
                            Text("consommation = ${consommationG.toStringAsFixed(2)} Th"),
                            Text("montant HT gaz = ${priceG.toStringAsFixed(2)}"),
                            Text("-------- "),
                            Text("contribution = ${contribution.toStringAsFixed(2)}"),
                            Text("total à payé = ${totalPrice!.toStringAsFixed(2)}"),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _generatePDF,
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text("Télécharger PDF"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}