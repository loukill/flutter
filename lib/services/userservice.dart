import 'dart:convert';
import 'package:flutter_dashboard/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl="http://localhost:3000/user";

  UserService();
  Future<Map<String, dynamic>> loginUser(String numTel , String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numTel': numTel , 'password': password}),
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

       if (responseData.containsKey('_id') && responseData.containsKey('name')) {
  // Assuming you want to check the existence of certain keys

  // Process the received data as needed
  final userId = responseData['_id'];
  final userName = responseData['name'];

  // Sauvegarder le token localement
  await saveSession('token', userId); // Adjust the saved value accordingly

  return responseData; // You might want to return specific data here if needed
} else {
  print('Invalid responseData format');
  throw Exception('Invalid responseData format');
}

      } else if (response.statusCode == 401) {
        // Handle invalid credentials
        print('Invalid credentials');
        throw Exception('Invalid credentials');
      } else {
        // Handle other errors
        print('Failed to login. Status code: ${response.statusCode}');
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during login: $error');
      throw Exception('Error during login: $error');
    }
  }

Future<void> registerUser(String name, String lastName, String numTel, String password) async {
  final url = '$baseUrl/UtilisateurSignUp'; // Replace with your actual endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'lastName': lastName,
        'numTel': numTel,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('User registered successfully');
    } else {
      // Handle non-200 responses
      print('Failed to register user: ${response.body}');
    }
  } catch (error) {
    // Handle network errors or JSON parsing errors
    print('Error occurred during user registration: $error');
  }
}

  Future<Map<String, dynamic>> logoutUser(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Logout successful, parse the response
      return jsonDecode(response.body);
    } else {
      // Logout failed, handle the error
      throw Exception('Failed to logout');
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String id,
      String email,
      String nom,
      String prenom,
      String adress,
      String cin,
      String userName,
      String imageRes) async {
    final response = await http.put(
      Uri.parse(
          '$baseUrl/user/$id'), // Use the appropriate endpoint for updating user by ID
      headers: {
        'Content-Type': 'application/json',
        // Add any other headers, such as authorization if needed
      },
      body: jsonEncode({
        'email': email,
        'nom': nom,
        'prenom': prenom,
        'adress': adress,
        'cin': cin,
        'userName': userName,
        'imageRes': imageRes,
      }),
    );

    if (response.statusCode == 200) {
      // Update successful, parse the response
      return jsonDecode(response.body);
    } else {
      // Update failed, handle the error
      throw Exception('Failed to update user');
    }
  }
  Future<void> newPassword(String numTel, String Password) async {
    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/resetPassword'), // Replace with your actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numTel': numTel, 'password': Password}),
      );

      if (response.statusCode == 200) {
        // Password updated successfully
        print('Password updated successfully for email: $numTel');
      } else {
        // Handle failure, maybe throw an exception or return an error message
        print('Failed to update password: ${response.statusCode}');
        throw Exception('Failed to update password');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error updating password: $error');
      throw Exception('Failed to update password');
    }
  }


  Future<http.Response> uploadImageToCloudinary(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/upload-image-to-cloudinary'), // Replace with your server endpoint
        body: {'imageUrl': imageUrl},
      );

      return response;
    } catch (error) {
      throw Exception('Error uploading image to Cloudinary: $error');
    }
  }

 Future<List<User>> getAllUsers() async {
  final response = await http.get(
    Uri.parse('$baseUrl/AllUsers'), // Replace with your actual API endpoint
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the users
    Iterable<dynamic> data = json.decode(response.body);
    List<User> users = List<User>.from(data.map((user) => User.fromJson(user)));
    return users;
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load users');
  }
}


  Future<void> saveSession(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> getSession(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  Future<User?> getLoggedInUser() async {
    try {
      // Récupérer le token d'authentification depuis SharedPreferences
      String? authToken = await getSession('token');

      if (authToken == null) {
        // Token non trouvé, gérer l'erreur
        print('Token d\'authentification non trouvé');
        return null;
      }

      final response = await http.get(
        Uri.parse('http://192.168.1.16:9090/auth/loggeduser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userJson = jsonDecode(response.body);
        print(response.body);
        // Créer un objet User
        User user = User.fromJson(userJson);

        // Afficher les champs individuels de l'objet User
        print('User Connected:');
        print('ID: ${user.email}');
        print('Email: ${user.numTel}');
        print('Nom: ${user.name}');
        //print('Prenom: ${user.prenom}');
        // Ajouter d'autres champs si nécessaire

        return user;
      } else {
        // Gérer la réponse d'erreur
        print(
            'Échec de la récupération des données de l\'utilisateur. Code d\'état : ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Gérer les erreurs réseau ou autres
      print(
          'Erreur lors de la récupération des données de l\'utilisateur : $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> sendResetCode(String email) async {
    print("send code");
    
    
    print(email);
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/forgetPassword'), // Replace with your actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numTel': email}),
      );

      if (response.statusCode == 200) {
        // Successful reset code sent, parse the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Handle failure, maybe throw an exception or return an error message
        throw Exception('Failed to send reset code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error sending reset code: $error');
      throw Exception('Failed to send reset code');
    }
  }

 Future<bool> verifyResetCode(String email, String enteredCode) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/verifyOTP'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numTel': email, 'otp': enteredCode}),
    );

    if (response.statusCode == 200) {
      // Server returned success, reset code is valid
      return true;
    } else {
      // Reset code is not valid
      return false;
    }
  } catch (error) {
    // Handle network errors or other exceptions
    print('Error verifying reset code: $error');
    throw Exception('Failed to verify reset code');
  }
}

Future<void> banUser(String userId) async {
  final response = await http.put(
    Uri.parse('$baseUrl/$userId/ban'),
  );

  if (response.statusCode == 200) {
    print('Utilisateur banni avec succès');
  } else {
    print('Erreur lors du bannissement : ${response.statusCode}');
  }
}

Future<void> unbanUser(String userId) async {
  final response = await http.put(
    Uri.parse('$baseUrl/$userId/unban'),
  );

  if (response.statusCode == 200) {
    print('Utilisateur débanni avec succès');
  } else {
    print('Erreur lors du débannissement : ${response.statusCode}');
  }
}

Future<void> banUserWithDuration(String userId, int durationInMinutes) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/$userId/banWithDuration'),
    body: {'durationInMinutes': durationInMinutes.toString()},
  );

  if (response.statusCode == 200) {
    print('Utilisateur banni avec succès pour une durée définie');
  } else {
    print('Erreur lors du bannissement avec durée : ${response.statusCode}');
  }
}


}
