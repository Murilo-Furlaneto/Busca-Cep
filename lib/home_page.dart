import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String localidade = "São Paulo";
  String logradouro = "Praça da Sé";
  String uf = "SP";
  String cep = "";
  final _formKey = GlobalKey<FormState>();

  Dio dio = Dio();
  Future getCep(String cep) async {
    try {
      var response = await dio.get("https://viacep.com.br/ws/$cep/json/");
      print(response);

      setState(() {
        var result = response.data;
        logradouro = result["logradouro"];
        localidade = result["localidade"];
        uf = result["uf"];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  logradouro,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  localidade,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  uf,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      height: 70,
                      width: 300,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Insira um CEP';
                          }
                          if (value.length < 8 || value.length > 8) {
                            return 'O CEP só pode conter 8 números';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            cep = value.toString();
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Digite o CEP...',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        getCep(cep);
                      }
                    },
                    child: const Text('Pesquisar',
                        style: TextStyle(fontSize: 16, color: Colors.black))),
              ),
            ],
          ),
      
      );
  
  }
}
