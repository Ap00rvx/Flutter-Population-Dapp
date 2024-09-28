import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLink extends ChangeNotifier {
  final String _rpc = "http://127.0.0.1:7545";
  final String _ws = "ws://127.0.0.1:7545";
  final String _privateKey =
      "7d904adecf00e4a2615b7168a3dc9c7382ec0aa611d73d3bef0b3beec4c5be2a";

  late Web3Client _web3client;
  bool isLoading = true;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;

  late ContractFunction _countryName;
  late ContractFunction _currentPopulation;
  late ContractFunction _set;
  late ContractFunction _decrement;
  late ContractFunction _increment;

  String countryName = '';
  String currentPopulation = '';

  ContractLink() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    _web3client = Web3Client(_rpc, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_ws).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
    await getData(); // Make sure initial data is fetched
  }

  Future<void> getAbi() async {
    final abiStringFile =
        await rootBundle.loadString("build/contracts/Population.json");
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _web3client.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Population"), _contractAddress);

    _countryName = _contract.function("countryName");
    _currentPopulation = _contract.function("population");
    _set = _contract.function("setName");
    _decrement = _contract.function("decrement");
    _increment = _contract.function("increment");
  }

  Future<void> getData() async {
    try {
      List<dynamic> name = await _web3client
          .call(contract: _contract, function: _countryName, params: []);
      List<dynamic> population = await _web3client
          .call(contract: _contract, function: _currentPopulation, params: []);

      countryName = name[0].toString();
      currentPopulation = population[0].toString();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addData(String nameData, BigInt countData) async {
    isLoading = true;
    notifyListeners();

    try {
      await _web3client.sendTransaction(
        _credentials,
        
        Transaction.callContract(
          
          contract: _contract,
          function: _set,
          parameters: [nameData, countData],
          gasPrice: EtherAmount.inWei(BigInt.one), // Set appropriate gas price
          maxGas: 100000,
           maxFeePerGas: EtherAmount.inWei(BigInt.from(4000000000)), // Set a reasonable max fee
    maxPriorityFeePerGas: EtherAmount.inWei(BigInt.from(2000000000)), // Adjust gas limit
        ),
        chainId: 1337
      );
      await getData();
    } catch (e) {
      print("Error setting data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> increasePopulation(int incrementBy) async {
    isLoading = true;
    notifyListeners();

    try {
      await _web3client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _increment,
          parameters: [BigInt.from(incrementBy)],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 100000, maxFeePerGas: EtherAmount.inWei(BigInt.from(4000000000)), // Set a reasonable max fee
    maxPriorityFeePerGas: EtherAmount.inWei(BigInt.from(2000000000)),
        ),
         chainId: 1337
      );
      await getData();
    } catch (e) {
      print("Error incrementing population: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> decreasePopulation(int decrementBy) async {
    isLoading = true;
    notifyListeners();

    try {
      await _web3client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _decrement,
          parameters: [BigInt.from(decrementBy)],
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 100000, maxFeePerGas: EtherAmount.inWei(BigInt.from(4000000000)), // Set a reasonable max fee
    maxPriorityFeePerGas: EtherAmount.inWei(BigInt.from(2000000000)),
        ),
         chainId: 1337
      );
      await getData();
    } catch (e) {
      print("Error decrementing population: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
