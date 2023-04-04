// @dart=2.9

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:winbrother_hr_app/constants/globals.dart';
import 'package:winbrother_hr_app/models/document.dart';
import 'package:winbrother_hr_app/models/document_detail.dart';
import 'package:winbrother_hr_app/models/document_folder.dart';
import 'package:winbrother_hr_app/models/document_list_model.dart';
import 'package:winbrother_hr_app/services/odoo_service.dart';

class DocumentService extends OdooService {
  Dio dioClient;
  @override
  Future<DocumentService> init() async {
    print('DocumentService has been initialize');
    dioClient = await client();
    return this;
  }

  Future<List<Documents>> getDocList(String empID) async {
    String filter = "[('employee_ref','='," + empID + ")]";
    String url = Globals.baseURL + "/hr.employee.document";
    //String url = Globals.baseURL + "/hr.employee/1/get_documents";
    Response response =
        await dioClient.get(url, queryParameters: {"filters": filter});
    List<Documents> doc_list = new List<Documents>();
    if (response.statusCode == 200) {
      print(response.toString());

      var list = response.data['results'];
      if (response.data['count'] != 0) {
        list.forEach((v) {
          doc_list.add(Documents.fromMap(v));
        });
      }
    }
    return doc_list;
  }


  Future<List<DocumentListModel>> getDocNameList(String empID) async {
    List<Document_folder> docFolderList= await getDocumentFolders(empID);
    String url = Globals.baseURL + "/hr.employee/1/get_documents";
    var data = jsonEncode({'employee_id' : empID});
    Response response =
    await dioClient.put(url,data: data);
    List<DocumentListModel> docListModels= new List<DocumentListModel>();
    List<Documents> doc_list = new List<Documents>();
    if (response.statusCode == 200) {

      var list = response.data;
      if (list !=null && list.length != 0) {
        list.forEach((v) {
          doc_list.add(Documents.fromMap(v));
        });
      }
    }

    docFolderList.forEach((folder) {
      docListModels.add(DocumentListModel(folder.folderName,doc_list.where((element) => element.folderId == folder.folderId).toList()));
    });

    return docListModels;
  }

  Future<Document_detail> getDocD(String docID) async {
    String url = Globals.baseURL + "/documents.document/" + docID;
    Response response = await dioClient.get(url);
    Document_detail doc = new Document_detail();
    if (response.statusCode == 200) {
      print(response.toString());
      var data = response.data;
      doc = Document_detail.fromJson(data);
    }
    return doc;
  }

  Future<List<Document_folder>> getDocumentFolders(String empID) async {
    String url = Globals.baseURL + "/hr.employee/1/get_folders/";
    Response response = await dioClient.put(url,data: jsonEncode({"employee_id":int.parse(empID)}));
    List<Document_folder> doc_folders = new List<Document_folder>();
    if (response.statusCode == 200) {
      print(response.toString());
      var list = response.data;
      if (list !=null && list.length != 0) {
        list.forEach((v) {
          doc_folders.add(Document_folder.fromJson(v));
        });
      }
    }
    return doc_folders;
  }

}
