//
//  HowYourDataIsManaged.swift
//  PPoint
//
//  Created by A. Ortega on 10/25/23.
//

import SwiftUI

struct HowYourDataIsManaged: View {
    
    var email : String = "calejo.ortega@hotmail.com"
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
        NavigationStack {
            ScrollView{

                
                
                VStack{
                    

                    
                    VStack(alignment: .leading){
                        Text("Términos y Condiciones")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        Text("Bienvenido a PicPoint, al utilizar nuestra aplicación, aceptas estos términos y condiciones. Si no estás de acuerdo con estos términos, no utilices nuestra aplicación.")
                            .padding(.bottom,10)
                        Text("Almacenamiento de información")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        Text("Nuestra aplicación está diseñada para almacenar toda la información dentro del dispositivo móvil del usuario. Esto incluye fotos, ubicación, precios, categorías y cualquier otra información que se obtenga a través de la aplicación. No utilizamos aplicaciones de terceros para la aplicación.")
                    }.padding(.bottom,10)
                    
                    VStack(alignment: .leading){
                        Text("Política de privacidad")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        Text("Nos tomamos muy en serio la privacidad de nuestros usuarios. No recopilamos ni almacenamos información personal de nuestros usuarios. Toda la información que se obtiene a través de la aplicación se almacena únicamente en el dispositivo móvil del usuario.")
                    }.padding(.bottom,10)
                    
                    VStack(alignment: .leading){
                        Text("Responsabilidad del usuario")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        Text("El usuario es responsable de cualquier información que comparta a través de nuestra aplicación. No nos hacemos responsables por el contenido compartido por el usuario.")
                            .padding(.bottom,10)
                        
                        Text("Contact")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        Text("If you have any questions about this Privacy Policy, feel free to get in touch \(email)")
                        
                    }.padding(.bottom,10)
                    


                }.padding(.horizontal,30)
                    .padding(.top, 20)
                

            }
            .navigationTitle("PicPoint & Privacy ")
            .toolbar{
                ToolbarItem(placement: .primaryAction) {
                    
                  
                    
                    Button("Done"){
                        dismiss()

                    }
                    
                    
                }
            }
        }
    }
}

#Preview {
    HowYourDataIsManaged()
}
