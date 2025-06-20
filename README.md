## JubiPago – Análisis y Diseño de Software

Este repositorio contiene el desarrollo del proyecto JubiPago, realizado en el marco del Taller de Proyecto de la carrera de Tecnicatura en las ciencias de la computación. El objetivo es diseñar y desarrollar una aplicación de pagos destinada a jubilados, enfocándose en la usabilidad, seguridad y eficiencia.

📄 Documentación

    Figma: Diseño de la interfaz de usuario.
    https://www.figma.com/design/T6FTRXlNtsrcSGkuEA8t5K/Untitled?node-id=0-1

    Miro: Diagramas de flujo y arquitectura del sistema.
    https://miro.com/welcomeonboard/dDZKQjl6NldwdnpabldQWmdxL0E5YVBzaTV6WGRTVWhFbWNSUXI0Q1V0SmJrUWJyc1dCSUNIN3dtS21qb2J4OVpXcEJ0VmVPbzRVNXlSRmMyK0haU2dnc2tNb0pYQVo2dldSRXAzRnh1VkhCMmRuTDgzam9JK1hTRHIyUk9RS3NyVmtkMG5hNDA3dVlncnBvRVB2ZXBnPT0hdjE

    Documentos clave:

        Product Backlog - JubiPago.pdf

        SRS.pdf (Especificación de Requisitos del Software)

        Diagramas UML:

            Contexto del sistema

            Clases

            Objetos

⚙️ Instalación

    Clonar el repositorio:

    git clone https://github.com/ValentinPastre/AnalisisYDise-o_Taller_Proyecto.git
    cd AnalisisYDise-o_Taller_Proyecto

    Construir la imagen Docker:

        docker-compose build

    Ejecutar el contenedor:

        docker-compose up
    
    Crear la base de datos:

        docker-compose exec app bundle exec rake db:drop

        docker-compose exec app bundle exec rake db:create
        
        docker-compose exec app bundle exec rake db:migrate

    Para migrar tablas individualmente:

        docker-compose exec app bundle exec rake db:migrate:up  VERSION="Numero de la migracion"

    Para acceder al sqlite:

        docker compose exec app sqlite3 db/wallet_development.sqlite3

🚀 Uso

    Una vez iniciado el contenedor, la aplicación estará disponible en http://localhost:8000. Desde allí, se puede interactuar con la interfaz de usuario diseñada para facilitar los pagos de los jubilados.

    Está hecha para descargar el repositorio y utilizarse. Ya damos datos de cuentas seteadas en un archivo "Datos de cuentas.txt" para utilizar la base de datos. Solamente es necesario construir la imagen docker y correrla.

⚠️ Solucionador de problemas

    Si llegan a haber problemas con la base de datos, se deben eliminar los archivos "schema.rb", "test.sqlite3",
    "wallet_development.sqlite3", "wallet_development.sqlite3-shm", "wallet_development.sqlite3-wal" y ejecutar los comandos listados más arriba para crear la base de datos.

    NOTA
    Si se realiza este proceso la base de datos será borrada, y los datos en "Datos de cuentas.txt" no funcionarán.


🛠️ Tecnologías utilizadas

    Ruby: Lenguaje de programación principal.

    Docker: Contenerización de la aplicación para facilitar su despliegue.

    Figma: Diseño de interfaces de usuario.

    Miro: Diagramación y planificación del proyecto.

👥 Autores

    Valentín Pastre

    Francisco Gribaudo
    
    Camilo Girardi
    
    Francisco Andeani
    
    Fabricio Parejo