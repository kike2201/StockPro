
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  bool _cargando = false;
  bool _mostrarContrasena = false;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _correoController.text.trim(),
        password: _contrasenaController.text,
      );

      // La pantalla principal se mostrará automáticamente
      // cuando conectemos el controlador de autenticación.

    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      String mensaje = 'No fue posible iniciar sesión.';

      if (error.code == 'invalid-credential' ||
          error.code == 'wrong-password' ||
          error.code == 'user-not-found') {
        mensaje = 'Correo o contraseña incorrectos.';
      } else if (error.code == 'invalid-email') {
        mensaje = 'El correo ingresado no es válido.';
      } else if (error.code == 'network-request-failed') {
        mensaje = 'Verifica tu conexión a Internet.';
      } else if (error.code == 'too-many-requests') {
        mensaje = 'Demasiados intentos. Intenta más tarde.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF17324D);
    const naranja = Color(0xFFED8618);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 90,
                    color: naranja,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'StockPro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: azul,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Acceso al sistema de inventario',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 36),

                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Ingresa tu correo';
                      }
                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(valor.trim())) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: _contrasenaController,
                    obscureText: !_mostrarContrasena,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _mostrarContrasena = !_mostrarContrasena;
                          });
                        },
                        icon: Icon(
                          _mostrarContrasena
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _iniciarSesion(),
                  ),

                  const SizedBox(height: 28),

                  FilledButton.icon(
                    onPressed: _cargando ? null : _iniciarSesion,
                    icon: const Icon(Icons.login),
                    label: Text(
                      _cargando
                          ? 'Ingresando...'
                          : 'Iniciar sesión',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: azul,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Gestión de productos, categorías y proveedores',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
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
