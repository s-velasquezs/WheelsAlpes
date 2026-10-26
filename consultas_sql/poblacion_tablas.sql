DECLARE
    TYPE tipo_paradas IS TABLE OF VARCHAR2(5)
        INDEX BY PLS_INTEGER;

    v_paradas tipo_paradas;
    v_documento VARCHAR2(10);
    v_pasajero VARCHAR2(10);
    v_viaje VARCHAR2(5);
    v_parada VARCHAR2(5);
    v_localidad VARCHAR2(20);
    v_numero_pasajero NUMBER;

BEGIN

    FOR i IN 1..170 LOOP

        v_documento := TO_CHAR(1000000000 + i);

        IF i <= 20 THEN

            INSERT INTO Estudiantes (
                documento_id, nombre, apellido,
                programa, universidad,
                correo_institucional, celular
            )
            VALUES (
                v_documento,
                'Conductor',
                'Estudiante' || i,
                'Ingenieria',
                'Uniandes',
                'e' || i || '@uniandes.edu.co',
                TO_CHAR(3000000000 + i)
            );

        ELSE

            INSERT INTO Estudiantes (
                documento_id, nombre, apellido,
                programa, universidad,
                correo_institucional, celular
            )
            VALUES (
                v_documento,
                'Pasajero',
                'Estudiante' || i,
                'Ingenieria',
                'Uniandes',
                'e' || i || '@uniandes.edu.co',
                TO_CHAR(3000000000 + i)
            );

        END IF;

    END LOOP;

    FOR i IN 1..20 LOOP

        INSERT INTO Conductor (documento_id)
        VALUES (TO_CHAR(1000000000 + i));

    END LOOP;

    FOR i IN 1..20 LOOP

        INSERT INTO Vehiculo (
            placa, marca, modelo, anio,
            color, cupos_disponibles, id_conductor
        )
        VALUES (
            'LOP' || LPAD(i, 3, '0'),
            'Toyota',
            'RAV4',
            2023,
            'GRIS',
            4,
            TO_CHAR(1000000000 + i)
        );

    END LOOP;

    FOR i IN 1..10 LOOP

        INSERT INTO Parada (id_parada, parada)
        VALUES (
            NULL,
            CASE i
                WHEN 1 THEN 'Chapinero'
                WHEN 2 THEN 'Usaquen'
                WHEN 3 THEN 'Suba'
                WHEN 4 THEN 'Kennedy'
                WHEN 5 THEN 'Teusaquillo'
                WHEN 6 THEN 'Engativa'
                WHEN 7 THEN 'Bosa'
                WHEN 8 THEN 'La Candelaria'
                WHEN 9 THEN 'Santa Fe'
                WHEN 10 THEN 'Ciudad Bolivar'
            END
        )
        RETURNING id_parada INTO v_parada;

        v_paradas(i) := v_parada;

    END LOOP;

    FOR d IN 1..20 LOOP

        v_localidad :=
            CASE MOD(d - 1, 5)
                WHEN 0 THEN 'Chapinero'
                WHEN 1 THEN 'Usaquen'
                WHEN 2 THEN 'Suba'
                WHEN 3 THEN 'Kennedy'
                WHEN 4 THEN 'Teusaquillo'
            END;

        FOR t IN 1..5 LOOP



            INSERT INTO Viaje (
                id_viaje,
                fecha_hora_salida,
                punto_origen,
                cupos_disponibles_viaje,
                costo,
                estado,
                ruta_general,
                placa,
                id_conductor
            )
            VALUES (
                NULL,
                DATE '2026-10-01'
                    + MOD((d - 1) * 5 + t - 1, 20)
                    + (7 + MOD(t, 5)) / 24,
                v_localidad,
                4,
                12000 + MOD(d, 5) * 1000,
                'COMPLETADO',
                'Ruta ' || v_localidad,
                'LOP' || LPAD(d, 3, '0'),
                TO_CHAR(1000000000 + d)
            )
            RETURNING id_viaje INTO v_viaje;


           

            INSERT INTO Viaje_Parada (
                id_viaje, id_parada
            )
            VALUES (
                v_viaje,
                v_paradas(MOD(d + t - 2, 10) + 1)
            );

            INSERT INTO Viaje_Parada (
                id_viaje, id_parada
            )
            VALUES (
                v_viaje,
                v_paradas(MOD(d + t + 2, 10) + 1)
            );


            

            FOR p IN 1..3 LOOP

                v_numero_pasajero :=
                    MOD(
                        (d - 1) * 15
                        + (t - 1) * 3
                        + p - 1,
                        150
                    ) + 21;

                v_pasajero :=
                    TO_CHAR(1000000000 + v_numero_pasajero);

                INSERT INTO Solicitud (
                    id_solicitud,
                    estado_solicitud,
                    id_pasajero,
                    id_viaje,
                    punto_recogida
                )
                VALUES (
                    NULL,
                    'ACEPTADA',
                    v_pasajero,
                    v_viaje,
                    'Parada asignada'
                );

            END LOOP;

        END LOOP;

    END LOOP;


    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;

END;
/