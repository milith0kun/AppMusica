# Informe Técnico Completo: Aplicación de Música para Terapeutas
## Especificación Técnica Detallada con Flutter y MongoDB

---

## 1. Resumen Ejecutivo

Este documento presenta las especificaciones técnicas completas para desarrollar una aplicación móvil de streaming de música especializada para terapeutas. La plataforma implementará modelo de suscripción (mensual/anual), streaming de audio protegido sin opción de descarga, biblioteca musical organizada, y panel administrativo para gestión de contenido. El stack tecnológico utilizará Flutter para aplicación móvil multiplataforma, Node.js/Express para backend, MongoDB para base de datos, y servicios especializados de streaming de audio con protección DRM.

---

## 2. Análisis del Proyecto

### 2.1 Descripción General

El proyecto consiste en desarrollar una plataforma digital que democratice el acceso a música terapéutica especializada mediante modelo de suscripción. Los terapeutas podrán acceder a biblioteca curada de composiciones musicales diseñadas específicamente para uso en sesiones terapéuticas, reproduciendo contenido vía streaming sin posibilidad de descarga para proteger derechos de autor y modelo de negocio.

### 2.2 Usuarios Objetivo

**Terapeutas Profesionales:** Psicólogos, musicoterapeutas, terapeutas ocupacionales, fisioterapeutas, consejeros, y profesionales de salud mental que utilizan música como herramienta terapéutica. Necesitan acceso confiable a música apropiada durante sesiones con pacientes, organizada por tipo de terapia, estado de ánimo, o técnica específica.

**Administradores del Sistema:** Personal encargado de gestionar biblioteca musical, subir nuevo contenido, organizar catálogo, gestionar suscripciones, y monitorear uso de plataforma. Requieren interfaz intuitiva que simplifique tareas administrativas complejas.

### 2.3 Objetivos del Producto

Crear plataforma confiable de streaming de audio con disponibilidad 99.5%+ que permita reproducción ininterrumpida durante sesiones terapéuticas críticas. Implementar protección robusta de contenido que prevenga descarga o distribución no autorizada. Proporcionar experiencia de usuario simple e intuitiva que permita a terapeutas encontrar y reproducir música apropiada en segundos. Establecer modelo de ingresos recurrentes mediante suscripciones gestionadas automáticamente.

### 2.4 Alcance del MVP

El producto mínimo viable incluirá: sistema de registro y autenticación con verificación de credenciales profesionales, gestión completa de suscripciones con integración de pagos (mensual y anual), reproductor de audio streaming con controles básicos (play, pausa, siguiente, anterior, progreso), biblioteca musical organizada por categorías y playlists, funcionalidad de búsqueda y filtrado, panel administrativo web para gestión de contenido, sistema de carga y procesamiento de archivos de audio, protección básica contra descarga mediante streaming seguro, y analytics básico de uso.

---

## 3. Stack Tecnológico Completo

### 3.1 Frontend Móvil: Flutter

Flutter se selecciona para desarrollo de aplicación móvil por capacidad de compilar nativamente a iOS y Android desde código único, reduciendo tiempo y costo de desarrollo. El rendimiento nativo es crucial para reproductor de audio que debe operar fluidamente sin interrupciones. La integración con paquetes especializados de audio como just_audio y audio_service permite implementar reproducción en background, controles de sistema operativo, y gestión eficiente de buffers.

### 3.2 Frontend Administrativo: React

El panel administrativo web se desarrollará con React por su ecosistema maduro, abundancia de componentes UI empresariales (Material-UI, Ant Design), y experiencia de desarrollo eficiente. React facilita crear interfaces complejas de gestión de contenido con formularios, tablas dinámicas, y flujos de carga de archivos. Next.js puede emplearse como framework sobre React para beneficios adicionales como renderizado del lado del servidor y optimización automática.

### 3.3 Backend: Node.js con Express

Node.js proporciona entorno ideal para aplicaciones de streaming por su modelo asíncrono no bloqueante que maneja eficientemente múltiples streams concurrentes. Express estructura el servidor con arquitectura RESTful clara. TypeScript añadirá tipado estático para mayor robustez en sistema que maneja transacciones financieras y contenido protegido.

### 3.4 Base de Datos: MongoDB

MongoDB almacenará todos los datos estructurados: perfiles de usuarios, información de suscripciones, metadata de canciones (título, artista, álbum, duración, categorías, tags), playlists, historial de reproducción, configuraciones. Su flexibilidad permite evolucionar esquemas conforme se añaden features sin migraciones complejas. MongoDB Atlas proporcionará cluster gestionado con replicación automática y backups.

### 3.5 Almacenamiento de Audio: Amazon S3 o Cloudflare R2

Los archivos de audio se almacenarán en object storage como Amazon S3 o Cloudflare R2 (alternativa económica compatible con S3). Estos servicios ofrecen almacenamiento escalable, durabilidad 99.999999999%, integración con CDN para entrega rápida global, y capacidad de generar URLs firmadas temporales que expiran, previniendo acceso no autorizado.

### 3.6 CDN y Streaming: Amazon CloudFront o Cloudflare

CloudFront o Cloudflare CDN distribuirán contenido de audio desde ubicaciones edge cercanas a usuarios, reduciendo latencia y mejorando experiencia de streaming. Soportan streaming adaptativo, compresión automática, y protección contra acceso directo a origin.

### 3.7 Procesamiento de Audio: AWS Lambda

Funciones serverless procesarán archivos de audio subidos: validación de formato, conversión a formatos optimizados (AAC, Opus), normalización de volumen, extracción de metadata, generación de waveforms para visualización. Lambda escala automáticamente según volumen de uploads sin provisionar servidores.

### 3.8 Gestión de Pagos: Stripe

Stripe manejará todo el flujo de suscripciones: registro de tarjetas, cobros recurrentes automáticos, gestión de fallos de pago, actualizaciones de planes, cancelaciones, y webhooks para sincronizar estado de suscripción. Stripe cumple estándares PCI-DSS eliminando responsabilidad de manejar datos sensibles de tarjetas.

### 3.9 Autenticación: JSON Web Tokens + OAuth 2.0

JWT gestionará autenticación stateless con tokens de corta duración. OAuth 2.0 permitirá login social opcional mediante Google o LinkedIn (apropiado para profesionales). Sistema de refresh tokens mantendrá sesiones sin requerir login frecuente.

### 3.10 Notificaciones: Firebase Cloud Messaging

FCM enviará notificaciones push sobre: confirmación de suscripción, próxima renovación, nuevo contenido disponible, recordatorios de sesiones, alertas de vencimiento de suscripción. Flutter tiene integración nativa con FCM.

### 3.11 Analytics: Mixpanel o Amplitude

Herramienta de analytics especializada rastreará eventos críticos: canciones reproducidas, tiempo de escucha, categorías más populares, tasas de conversión de trial a pago, churn rate, engagement por cohortes. Estos insights informarán decisiones de producto y contenido.

### 3.12 Monitoreo: Sentry + Datadog

Sentry capturará errores y crashes en aplicación móvil y backend. Datadog monitoreará performance del sistema: latencia de APIs, uso de recursos, disponibilidad de servicios, tasas de error. Alertas automáticas notificarán anomalías.

### 3.13 Email Transaccional: SendGrid

SendGrid enviará emails transaccionales: bienvenida, confirmación de registro, recibos de pago, notificación de renovación, recordatorio de vencimiento, recuperación de contraseña. Templates HTML profesionales y tracking de aperturas.

---

## 4. Arquitectura del Sistema

### 4.1 Arquitectura General

El sistema implementa arquitectura de tres capas con componentes distribuidos:

**Capa de Presentación:** Aplicación Flutter móvil para terapeutas usuarios finales, y aplicación web React para administradores. Ambas consumen APIs REST del backend.

**Capa de Lógica de Negocio:** Servidor Node.js/Express hospedado en contenedores Docker, exponiendo APIs RESTful para autenticación, gestión de usuarios, catálogo musical, reproducción, suscripciones, y administración. Integra con servicios externos (Stripe, S3, etc).

**Capa de Datos:** MongoDB Atlas almacena datos estructurados. Amazon S3 almacena archivos de audio. Redis cachea metadata frecuentemente accedida y gestiona sesiones. Elasticsearch indexa contenido para búsqueda rápida.

### 4.2 Flujo de Streaming de Audio

El streaming de audio protegido sigue este flujo:

1. Usuario solicita reproducir canción mediante app Flutter
2. App envía request a backend con token JWT
3. Backend valida token y suscripción activa del usuario
4. Backend consulta MongoDB para obtener metadata de canción
5. Backend genera URL firmada temporal (válida 1 hora) de archivo en S3
6. Backend registra evento de reproducción en analytics
7. Backend retorna URL firmada y metadata a app
8. App Flutter inicia streaming desde URL usando just_audio
9. Audio se descarga progresivamente (buffering) pero nunca se almacena permanentemente
10. Al expirar URL, usuario debe solicitar nueva si quiere continuar

Este modelo previene descarga ya que URLs son temporales, específicas por usuario, y el archivo nunca se guarda localmente de forma permanente.

### 4.3 Protección de Contenido

Múltiples capas de protección previenen piratería:

**URLs Firmadas Temporales:** Cada URL incluye firma criptográfica que valida con clave secreta del servidor, expira en tiempo determinado (30-60 minutos), y puede restringirse a IP específica.

**Sin Almacenamiento Local Permanente:** El reproductor bufferiza segmentos pequeños en memoria RAM que se descartan al cerrar app. No se implementa caché persistente.

**Detección de Screen Recording:** En iOS y Android, detectar cuando usuario graba pantalla y pausar reproducción automáticamente.

**Watermarking de Audio (opcional):** Insertar marcas de agua inaudibles con ID de usuario en stream para rastrear origen de grabaciones ilegales.

**Rate Limiting:** Limitar número de canciones que un usuario puede reproducir simultáneamente (máximo 1 stream activo) y número de reproducciones por hora.

**HTTPS Obligatorio:** Todo el tráfico cifrado con TLS 1.3 previene interceptación.

### 4.4 Arquitectura de Base de Datos

MongoDB organizará datos en colecciones especializadas que detallo extensamente en sección posterior. La estructura se optimizará para consultas frecuentes: búsqueda de canciones por categoría, recuperación de playlists completas, validación rápida de estado de suscripción.

---

## 5. Diseño de Base de Datos MongoDB

### 5.1 Colección: users

Almacena información de terapeutas usuarios de la plataforma.

**Campos principales:** identificador único, email único como credencial de login, hash de contraseña con bcrypt, nombre completo, profesión/especialización terapéutica (psicólogo, musicoterapeuta, fisioterapeuta, etc), número de licencia profesional para verificación (opcional), país y ciudad para analytics regional, timestamp de registro, timestamp de último acceso, estado de cuenta (activo, suspendido, cancelado).

**Información de suscripción embebida:** identificador de cliente en Stripe, plan actual (mensual, anual, trial, none), estado de suscripción (active, past_due, canceled, trialing), fecha de inicio de suscripción, fecha de próxima renovación, fecha de cancelación si aplica, método de pago guardado (últimos 4 dígitos de tarjeta para referencia).

**Preferencias:** idioma de interfaz, notificaciones habilitadas, calidad de audio preferida (normal 128kbps, alta 256kbps), reproducción automática de siguiente canción, historial de reproducción habilitado.

**Verificación profesional:** indicador de verificación completada, documentos subidos para verificación, fecha de verificación, verificado por (admin ID).

**Índices:** email único, estado de suscripción para filtrar usuarios activos, fecha de próxima renovación para procesar renovaciones.

### 5.2 Colección: songs

Almacena metadata completa de cada composición musical.

**Campos principales:** identificador único, título de la canción, artista o compositor, álbum o colección, año de composición, duración en segundos con precisión de milisegundos.

**Archivos de audio:** URL del archivo en S3 (key del objeto), formato del archivo (MP3, AAC, FLAC), bitrate (128kbps, 256kbps), tamaño del archivo en bytes, checksum MD5 para verificar integridad.

**Metadata adicional:** tempo en BPM (beats por minuto), tonalidad musical, instrumento principal, tipo de composición (instrumental, vocal, ambiental, rítmica).

**Clasificación terapéutica:** array de categorías terapéuticas (relajación, energización, meditación, procesamiento emocional, activación cognitiva, acompañamiento de dolor), array de emociones asociadas (calma, alegría, tristeza, reflexión, esperanza), usos recomendados (inicio de sesión, trabajo profundo, cierre, transición), intensidad emocional (baja, media, alta).

**Información administrativa:** fecha de subida, subido por (admin ID), estado (activo, inactivo, revisión), número de reproducciones total, reproducciones últimos 30 días, rating promedio si se implementa sistema de calificación.

**Waveform:** URL de imagen de waveform para visualización en reproductor.

**Índices compuestos:** categorías terapéuticas + estado para filtrado eficiente, título para búsqueda de texto, número de reproducciones para ordenar por popularidad.

### 5.3 Colección: albums

Agrupa canciones relacionadas en colecciones lógicas.

**Campos principales:** identificador único, título del álbum, descripción larga, artista o grupo de compositores, año de publicación, portada (URL de imagen en S3), array de referencias a canciones en orden específico, duración total calculada sumando canciones, número de canciones.

**Clasificación:** categoría principal del álbum, tags descriptivos, uso terapéutico recomendado.

**Información administrativa:** fecha de creación, creado por (admin ID), estado, popularidad calculada.

**Índices:** categoría, estado, popularidad.

### 5.4 Colección: playlists

Listas de reproducción temáticas curadas por administradores o creadas por usuarios.

**Campos principales:** identificador único, título de la playlist, descripción, imagen de portada (URL), tipo (curada por admin, creada por usuario, generada automáticamente), creador (user ID si es de usuario, admin ID si es curada), array de referencias a canciones con orden preservado, duración total, número de canciones.

**Visibilidad:** pública (visible a todos los usuarios), privada (solo creador), destacada (aparece en sección principal).

**Metadata:** categorías cubiertas, uso recomendado, actualizado por última vez.

**Estadísticas:** número de reproducciones, número de usuarios que la han guardado como favorita.

**Índices:** creador para listar playlists de usuario, tipo y visibilidad para filtrar, estado destacado para página principal.

### 5.5 Colección: playback_history

Registra historial de reproducción de cada usuario para análisis y recomendaciones.

**Campos principales:** identificador único, referencia a usuario, referencia a canción, timestamp de inicio de reproducción, timestamp de fin o pausa, duración real escuchada en segundos (puede ser menor que duración total si usuario saltó), porcentaje completado, dispositivo utilizado (iOS, Android, modelo), ubicación aproximada (país, ciudad) basándose en IP.

**Contexto:** desde dónde se reprodujo (búsqueda, playlist, álbum, recomendación), reproducción completada o interrumpida.

**Índices compuestos:** usuario + timestamp para historial personal ordenado cronológicamente, canción + timestamp para analytics de canción específica, timestamp para reportes temporales.

### 5.6 Colección: subscriptions

Registra detalle completo de suscripciones para auditoría y análisis, complementando datos embebidos en users.

**Campos principales:** identificador único, referencia a usuario, ID de suscripción en Stripe, estado (trialing, active, past_due, canceled, unpaid), plan (monthly, annual), precio pagado, moneda, fecha de inicio, fecha de fin de trial si aplica, fecha de próxima facturación.

**Histórico de cambios:** array de eventos con timestamp, tipo de evento (created, renewed, canceled, payment_failed, upgraded, downgraded), monto facturado, método de pago utilizado.

**Información de cancelación:** fecha de cancelación, razón de cancelación (dropdown seleccionado por usuario), comentarios adicionales, cancelado por usuario o por admin.

**Índices:** usuario para recuperar historial, estado para filtrar activas, fecha de próxima facturación para procesar renovaciones automáticas.

### 5.7 Colección: payments

Registra cada transacción de pago para contabilidad y resolución de disputas.

**Campos principales:** identificador único, referencia a usuario, referencia a suscripción, ID de transacción en Stripe (charge ID o invoice ID), monto, moneda, estado (succeeded, pending, failed, refunded), fecha de transacción.

**Detalles:** método de pago (últimos 4 dígitos de tarjeta, tipo de tarjeta), descripción (Suscripción Mensual Octubre 2025), recibo (URL de PDF generado por Stripe).

**Información de fallo:** código de error si falló, mensaje de error, número de intentos de cobro.

**Índices:** usuario para historial de pagos, estado, fecha de transacción.

### 5.8 Colección: favorites

Almacena canciones y playlists marcadas como favoritas por usuarios.

**Campos principales:** identificador único, referencia a usuario, tipo de favorito (song, playlist, album), referencia al item favorito, fecha de agregación.

**Índices compuestos:** usuario + tipo para listar favoritos por categoría, usuario + item para verificar si ya está en favoritos evitando duplicados.

### 5.9 Colección: categories

Define categorías terapéuticas del sistema con metadata descriptiva.

**Campos principales:** identificador único, nombre de categoría (Relajación Profunda, Energización, Meditación Guiada, etc), descripción extensa, icono (nombre o URL), color hex para identificación visual, orden de presentación en interfaz, estado activo.

**Metadata:** número de canciones en esta categoría (calculado), popularidad (basada en reproducciones).

**Recomendaciones de uso:** texto libre describiendo cuándo y cómo usar música de esta categoría.

### 5.10 Colección: admin_users

Usuarios administradores del panel web separados de terapeutas.

**Campos principales:** identificador único, email, hash de contraseña, nombre completo, rol (superadmin, editor, soporte), permisos (array de acciones permitidas: upload_songs, delete_songs, manage_users, view_analytics, manage_subscriptions), fecha de creación, último acceso.

**Auditoría:** indicador de cuenta activa, creado por (admin ID), historial de cambios de permisos.

**Índices:** email único, rol.

### 5.11 Colección: audit_logs

Registra todas las acciones administrativas para auditoría y seguridad.

**Campos principales:** identificador único, timestamp, admin que realizó acción, tipo de acción (upload_song, delete_song, edit_user, change_subscription, etc), entidad afectada (user ID, song ID, etc), detalles de cambios (objeto con valores previos y nuevos), dirección IP del admin, resultado (success, failure).

**Índices:** admin para rastrear acciones de usuario específico, timestamp para búsquedas temporales, tipo de acción para filtrar.

### 5.12 Colección: search_queries

Almacena búsquedas de usuarios para mejorar experiencia y descubrir necesidades de contenido.

**Campos principales:** identificador único, referencia a usuario, query de búsqueda (texto), timestamp, número de resultados retornados, resultado clickeado (song ID si usuario seleccionó alguno).

**Índices:** usuario para análisis personal, timestamp para tendencias temporales.

### 5.13 Colección: notifications

Gestiona notificaciones enviadas a usuarios.

**Campos principales:** identificador único, referencia a usuario, tipo (subscription_renewed, new_content, trial_ending, payment_failed, etc), título, mensaje, datos adicionales (JSON con información específica como song IDs), timestamp de creación, timestamp de envío, timestamp de lectura, canales (push, email, in_app), estado de entrega por canal.

**Índices:** usuario + leído para listar no leídas, timestamp.

---

## 6. API RESTful Completa

### 6.1 Estructura Base de URLs

Todas las URLs incluirán versionado: `/api/v1/`

Respuestas siguen formato JSON consistente con wrapper de datos y metadata.

Autenticación mediante header: `Authorization: Bearer {jwt_token}`

### 6.2 Módulo de Autenticación

**POST /api/v1/auth/register**
Registra nuevo terapeuta. Body: email, password, fullName, profession, country, city. Valida email único, fortaleza de contraseña, formato correcto. Crea usuario con estado trial de 7 o 14 días. Envía email de bienvenida con pasos de verificación profesional. Retorna tokens y perfil. Código 201.

**POST /api/v1/auth/login**
Autentica usuario. Body: email, password. Valida credenciales y verifica cuenta activa. Actualiza último acceso. Retorna access token (30 min), refresh token (30 días), y perfil completo incluyendo estado de suscripción. Código 200 éxito, 401 credenciales inválidas, 403 cuenta suspendida.

**POST /api/v1/auth/refresh**
Renueva access token. Body: refreshToken. Valida refresh token, verifica usuario activo, genera nuevo access token. Retorna nuevo access token. Código 200 éxito, 401 token inválido.

**POST /api/v1/auth/logout**
Cierra sesión. Invalida refresh token añadiéndolo a blacklist en Redis. Código 200.

**POST /api/v1/auth/forgot-password**
Inicia recuperación. Body: email. Genera token de reseteo válido 1 hora, envía email con enlace. Código 200 siempre (no revela si email existe).

**POST /api/v1/auth/reset-password**
Completa reseteo. Body: token, newPassword. Valida token no expirado, hashea nueva contraseña, invalida token. Código 200 éxito, 400 token inválido.

**POST /api/v1/auth/verify-professional**
Sube documentos de verificación profesional. Multipart form con archivos de licencia/certificado. Almacena documentos en S3, marca usuario como pendiente de revisión. Notifica admins. Código 200.

### 6.3 Módulo de Usuarios

**GET /api/v1/users/profile**
Obtiene perfil del usuario autenticado. Retorna objeto completo incluyendo información de suscripción, favoritos, estadísticas básicas. Código 200.

**PUT /api/v1/users/profile**
Actualiza perfil. Body puede incluir: fullName, profession, city, preferences. No permite cambiar email o password por este endpoint. Código 200.

**PUT /api/v1/users/preferences**
Actualiza solo preferencias. Body: language, audioQuality, autoplay, notificationsEnabled. Código 200.

**POST /api/v1/users/change-password**
Cambia contraseña. Body: currentPassword, newPassword. Valida actual, hashea nueva. Código 200 éxito, 400 contraseña actual incorrecta.

**GET /api/v1/users/subscription**
Obtiene detalle completo de suscripción: plan, estado, fechas, método de pago, historial de pagos recientes. Código 200.

**DELETE /api/v1/users/account**
Elimina cuenta (soft delete). Cancela suscripción automáticamente, marca usuario como inactivo, preserva datos por 30 días para recuperación potencial. Código 200.

### 6.4 Módulo de Catálogo Musical

**GET /api/v1/songs**
Lista canciones con paginación y filtrado. Query params: page (default 1), limit (default 20, max 100), category (filter), search (búsqueda de texto), sortBy (title, duration, popularity, recent), sortOrder (asc, desc). Retorna array de songs con metadata completa excepto URLs de archivo (solo se proveen al solicitar reproducción), total de resultados, página actual. Código 200.

**GET /api/v1/songs/:songId**
Obtiene detalle completo de canción específica incluyendo toda la metadata pero sin URL de archivo. Código 200 éxito, 404 no existe.

**GET /api/v1/songs/:songId/stream**
Obtiene URL firmada para streaming. Valida suscripción activa del usuario. Genera URL firmada de S3 válida 60 minutos. Registra inicio de reproducción en playback_history. Retorna objeto con streamUrl, expiresAt, metadata de canción. Código 200 éxito, 403 suscripción inactiva, 404 canción no existe.

**GET /api/v1/albums**
Lista álbumes. Query params similares a songs. Retorna array de albums con canciones embebidas o referencias según query param includesSongs. Código 200.

**GET /api/v1/albums/:albumId**
Detalle de álbum incluyendo todas las canciones con metadata completa. Código 200 éxito, 404 no existe.

**GET /api/v1/categories**
Lista todas las categorías terapéuticas activas ordenadas. Incluye contador de canciones por categoría. Código 200.

**GET /api/v1/categories/:categoryId/songs**
Lista canciones de categoría específica con paginación. Código 200.

### 6.5 Módulo de Playlists

**GET /api/v1/playlists**
Lista playlists públicas y curadas más las privadas del usuario autenticado. Query params: type (curated, user, featured), page, limit. Código 200.

**GET /api/v1/playlists/:playlistId**
Detalle de playlist con canciones completas. Valida que usuario tiene acceso (pública o propia). Código 200 éxito, 403 sin acceso, 404 no existe.

**POST /api/v1/playlists**
Crea playlist personal. Body: title, description, songIds (array). Valida que todas las canciones existen. Crea playlist de tipo user asociada al usuario. Código 201.

**PUT /api/v1/playlists/:playlistId**
Actualiza playlist propia. Body: title, description, songIds. Valida pertenencia. Código 200 éxito, 403 no es propietario.

**DELETE /api/v1/playlists/:playlistId**
Elimina playlist propia. Código 200 éxito, 403 no es propietario.

**POST /api/v1/playlists/:playlistId/songs**
Añade canciones a playlist. Body: songIds (array). Código 200.

**DELETE /api/v1/playlists/:playlistId/songs/:songId**
Elimina canción de playlist. Código 200.

### 6.6 Módulo de Favoritos

**GET /api/v1/favorites**
Lista favoritos del usuario. Query param: type (song, playlist, album) para filtrar. Retorna array con items completos. Código 200.

**POST /api/v1/favorites**
Añade item a favoritos. Body: type, itemId. Valida que item existe y no está ya en favoritos. Código 201 éxito, 409 ya existe.

**DELETE /api/v1/favorites/:favoriteId**
Elimina de favoritos. Código 200 éxito, 404 no existe.

**GET /api/v1/favorites/check/:type/:itemId**
Verifica si item está en favoritos. Retorna booleano. Útil para UI. Código 200.

### 6.7 Módulo de Búsqueda

**GET /api/v1/search**
Búsqueda global. Query param: q (query string), type (song, playlist, album, all), limit. Busca en títulos, artistas, descripciones usando texto completo de MongoDB o Elasticsearch. Registra búsqueda en search_queries. Retorna objeto con resultados separados por tipo. Código 200.

**GET /api/v1/search/suggestions**
Sugerencias de autocompletado. Query param: q (mínimo 2 caracteres). Retorna array de strings con sugerencias basadas en búsquedas populares y metadata. Código 200.

### 6.8 Módulo de Historial

**GET /api/v1/history**
Historial de reproducción del usuario. Query params: page, limit, desde, hasta (fechas). Retorna array de playback_history con canciones embebidas, ordenado cronológicamente descendente. Código 200.

**POST /api/v1/history/log**
Registra evento de reproducción (llamado automáticamente por app al finalizar). Body: songId, duration, percentageCompleted, source. Crea registro en playback_history. Código 201.

**GET /api/v1/history/stats**
Estadísticas personales. Retorna: total de canciones escuchadas, tiempo total de escucha, canción más reproducida, categoría favorita (inferida), tendencia de uso últimos 7 días. Código 200.

### 6.9 Módulo de Suscripciones

**GET /api/v1/subscriptions/plans**
Lista planes disponibles. Retorna array con: planId, name, price, currency, interval (month, year), features (array de strings descriptivos), stripeProductId. Código 200 (público, sin auth).

**POST /api/v1/subscriptions/create**
Crea suscripción nueva. Body: planId, paymentMethodId (obtenido de Stripe.js en frontend). Valida usuario no tenga suscripción activa. Crea cliente en Stripe si no existe. Crea suscripción en Stripe. Actualiza usuario con datos de suscripción. Envía email de confirmación. Código 201 éxito, 400 ya tiene suscripción, 402 pago falló.

**POST /api/v1/subscriptions/update**
Actualiza plan (upgrade/downgrade). Body: newPlanId. Stripe maneja proration automáticamente. Actualiza suscripción en Stripe y localmente. Código 200.

**POST /api/v1/subscriptions/cancel**
Cancela suscripción. Query param: immediate (true para cancelar inmediatamente, false para fin de periodo actual). Marca en Stripe como cancelada. Actualiza localmente. Envía email de confirmación. Código 200.

**POST /api/v1/subscriptions/reactivate**
Reactiva suscripción cancelada si aún está en periodo pagado. Código 200 éxito, 400 no puede reactivar.

**POST /api/v1/subscriptions/payment-method**
Actualiza método de pago. Body: paymentMethodId. Actualiza en Stripe. Código 200.

**POST /api/v1/webhooks/stripe**
Endpoint para webhooks de Stripe (sin autenticación JWT, valida firma de Stripe). Procesa eventos: invoice.paid (confirma renovación), invoice.payment_failed (marca past_due, envía alerta), customer.subscription.deleted (marca cancelada), customer.subscription.updated (sincroniza cambios). Código 200 siempre para ack a Stripe.

### 6.10 Módulo Administrativo

**POST /api/v1/admin/login**
Login específico para admins. Credenciales separadas de usuarios regulares. Genera tokens con permisos administrativos. Código 200.

**GET /api/v1/admin/users**
Lista todos los usuarios con filtros: status (active, suspended, canceled), plan, search. Incluye información de suscripción y última actividad. Paginado. Código 200.

**GET /api/v1/admin/users/:userId**
Detalle completo de usuario incluyendo historial de pagos, actividad reciente, estadísticas de uso. Código 200.

**PUT /api/v1/admin/users/:userId/status**
Cambia estado de cuenta. Body: status (active, suspended), reason. Suspender previene login. Código 200.

**PUT /api/v1/admin/users/:userId/subscription**
Modifica suscripción manualmente (override). Body: plan, expiresAt. Útil para extender trials, compensar problemas. Registra en audit_logs. Código 200.

**POST /api/v1/admin/songs**
Sube nueva canción. Multipart form: archivo de audio, título, artista, álbum, categorías, tags. Sube archivo a S3, extrae metadata con librería, procesa audio con Lambda (normalización, formatos), extrae waveform, crea documento en MongoDB. Código 201.

**PUT /api/v1/admin/songs/:songId**
Actualiza metadata de canción. Body con campos a modificar. No permite cambiar archivo (debe eliminarse y subirse nueva). Código 200.

**DELETE /api/v1/admin/songs/:songId**
Elimina canción (soft delete). Marca como inactiva, elimina de playlists, mantiene historial. Código 200.

**POST /api/v1/admin/albums**
Crea álbum. Body: title, description, coverImage, songIds. Sube portada a S3, crea documento. Código 201.

**PUT /api/v1/admin/albums/:albumId**
Actualiza álbum. Código 200.

**DELETE /api/v1/admin/albums/:albumId**
Elimina álbum (no elimina canciones asociadas). Código 200.

**POST /api/v1/admin/playlists**
Crea playlist curada. Body similar a álbum. Marca tipo como curated. Código 201.

**PUT /api/v1/admin/playlists/:playlistId/featured**
Marca/desmarca playlist como destacada. Body: featured (boolean). Código 200.

**GET /api/v1/admin/analytics/overview**
Dashboard principal: usuarios activos, suscripciones por plan, ingresos mensuales, canciones más reproducidas, categorías populares, churn rate. Código 200.

**GET /api/v1/admin/analytics/users**
Analytics de usuarios: registros por periodo, conversión trial a pago, tasa de retención por cohortes, distribución geográfica. Query params para rango de fechas. Código 200.

**GET /api/v1/admin/analytics/content**
Analytics de contenido: canciones más/menos reproducidas, categorías populares, tendencias temporales, canciones sin reproducciones. Código 200.

**GET /api/v1/admin/analytics/revenue**
Reporte financiero: ingresos por periodo, MRR (Monthly Recurring Revenue), ARR (Annual), LTV (Lifetime Value promedio), proyecciones. Código 200.

**GET /api/v1/admin/audit-logs**
Visualiza logs de auditoría. Filtros por admin, acción, fecha. Paginado. Código 200.

**POST /api/v1/admin/notifications/send**
Envía notificación masiva. Body: userIds (array o "all"), type, title, message, channels (push, email). Encola notificaciones para procesamiento asíncrono. Código 202 (accepted).

---

## 7. Arquitectura de la Aplicación Flutter

### 7.1 Estructura de Directorios

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── errors/
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── song_model.dart
│   │   ├── album_model.dart
│   │   ├── playlist_model.dart
│   │   └── subscription_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── music_repository.dart
│   │   ├── subscription_repository.dart
│   │   └── playback_repository.dart
│   └── services/
│       ├── api_service.dart
│       ├── audio_service.dart
│       ├── storage_service.dart
│       └── payment_service.dart
├── features/
│   ├── auth/
│   ├── home/
│   ├── player/
│   ├── library/
│   ├── search/
│   ├── profile/
│   └── subscription/
└── main.dart
```

### 7.2 Módulos Principales

**Módulo de Autenticación:** Pantallas de login, registro, recuperación de contraseña, verificación profesional con carga de documentos.

**Módulo de Home:** Pantalla principal mostrando playlists destacadas, categorías terapéuticas, álbumes recientes, continuar escuchando.

**Módulo de Reproductor:** Reproductor de audio completo con controles (play/pausa, siguiente, anterior, seek), visualización de waveform, información de canción actual, cola de reproducción, modos de repetición y aleatorio, controles de bloqueo de pantalla y notificación del sistema, compatibilidad con AirPlay y Chromecast.

**Módulo de Biblioteca:** Tabs para canciones favoritas, playlists personales, álbumes guardados, historial de reproducción reciente.

**Módulo de Búsqueda:** Campo de búsqueda con sugerencias en tiempo real, filtros por tipo, resultados categorizados.

**Módulo de Perfil:** Información personal, gestión de suscripción, configuraciones, ayuda y soporte, cerrar sesión.

**Módulo de Suscripción:** Visualización de planes, flujo de compra con Stripe, gestión de método de pago, cancelación.

### 7.3 Reproductor de Audio

El reproductor utilizará paquete **just_audio** para reproducción de audio con características avanzadas: streaming progresivo desde URLs, buffeizado inteligente, reproducción en background, sincronización con controles del sistema operativo.

**audio_service** permitirá reproducción continua en background incluso cuando app esté cerrada o pantalla bloqueada. Actualizará metadata en controles del sistema (pantalla de bloqueo, centro de control) con título, artista, portada.

**audio_session** gestionará sesiones de audio apropiadamente para no interferir con otras apps (llamadas telefónicas, alarmas, navegación).

El flujo de reproducción seguirá patrón:
1. Usuario selecciona canción desde cualquier parte de la app
2. App envía request a backend para obtener URL firmada
3. Backend valida suscripción y retorna URL temporal
4. App configura just_audio con URL
5. Audio comienza a bufferizar y reproduce automáticamente
6. App actualiza UI con información de reproducción
7. audio_service sincroniza con controles del sistema
8. Cuando canción termina o usuario salta, se repite proceso para siguiente canción
9. Al cerrar app o bloquear pantalla, reproducción continúa en background

### 7.4 Gestión de Estado

**Riverpod** manejará estado global: información de usuario autenticado, estado de suscripción, canción actualmente en reproducción, cola de reproducción, favoritos en caché.

**Estado del Reproductor:** Provider dedicado manejará: canción actual, posición de reproducción, estado (playing, paused, buffering), cola de siguiente reproducción, modo de repetición, modo aleatorio.

**Estado de Biblioteca:** Provider cachea favoritos y playlists localmente para acceso instantáneo, sincronizando con backend en background.

### 7.5 Caché y Offline

Aunque la app requiere conexión para streaming, implementará caché inteligente de metadata:

**SQLite local** almacena: información de canciones recientemente reproducidas (title, artist, portada), playlists y favoritos para navegación offline, historial de búsquedas.

**Imágenes cacheadas** con **cached_network_image**: portadas de álbumes, avatares, waveforms se cachean localmente para carga instantánea.

La app mostrará interfaz completa offline permitiendo navegar biblioteca, ver favoritos, y cola de reproducción, pero indicará claramente que requiere conexión para reproducir.

---

## 8. Panel Administrativo Web

### 8.1 Tecnologías

**React** con **TypeScript** para type safety. **Next.js** como framework proporcionando routing, SSR opcional, y optimización automática. **Material-UI** o **Ant Design** para componentes empresariales profesionales (tablas, formularios, modals, dashboards). **React Query** para gestión de estado del servidor, caché automático, y revalidación. **Recharts** o **Chart.js** para visualizaciones de analytics.

### 8.2 Estructura de Páginas

**Login Admin:** Autenticación separada con credenciales administrativas, 2FA opcional con código TOTP.

**Dashboard Principal:** KPIs en cards: usuarios activos, suscripciones activas, ingresos del mes, nuevos registros del día. Gráficos de tendencias: registros últimos 30 días, ingresos mensuales último año, distribución de planes. Lista de actividad reciente.

**Gestión de Usuarios:** Tabla paginada y filtrable con todos los usuarios mostrando: nombre, email, plan, estado suscripción, fecha registro, última actividad. Búsqueda por nombre/email. Filtros por estado, plan. Acciones rápidas: ver detalle, suspender, cambiar plan. Al hacer clic en usuario, modal o página detalle con: información completa, historial de pagos, actividad de reproducción, opción de enviar notificación personalizada, log de cambios administrativos.

**Gestión de Contenido Musical:** Sección para Canciones con tabla mostrando todas las canciones, búsqueda, filtros por categoría, estado. Botón prominente "Subir Nueva Canción". Al hacer clic, modal/página con formulario: upload de archivo de audio (drag & drop, validación de formato), campos de metadata (título, artista, álbum, duración se auto-detecta), selector múltiple de categorías terapéuticas, tags descriptivos, upload opcional de portada personalizada. Al enviar, muestra progreso de subida, procesamiento en backend, confirmación al completar.

Sección para Álbumes similar con creación desde canciones existentes.

Sección para Playlists Curadas con editor visual drag-and-drop para ordenar canciones, opción de marcar como destacada.

**Analytics:** Tabs separando diferentes vistas. Tab Usuarios con métricas de adquisición, retención, churn. Tab Contenido con canciones más reproducidas, categorías populares, contenido sin uso. Tab Financiero con MRR, ARR, proyecciones, tasa de cancelación. Tab Técnico con latencia de APIs, uptime, errores recientes. Todos con selectores de rango de fechas y opciones de exportación a CSV/PDF.

**Notificaciones:** Interfaz para enviar notificaciones masivas. Selector de audiencia (todos, usuarios de plan específico, usuarios inactivos últimos X días). Composer de mensaje con título y cuerpo. Preview en diferentes dispositivos. Selector de canales (push, email). Programación opcional (enviar ahora o fecha/hora específica).

**Configuración:** Gestión de admins (crear, modificar permisos, desactivar). Configuración de planes de suscripción (precios, features). Integración de servicios (claves API, webhooks). Logs de auditoría con filtros.

### 8.3 Upload y Procesamiento de Audio

El flujo de subida de audio implementará:

**Frontend:** Componente de drag-and-drop acepta archivos. Valida tipo MIME (audio/mpeg, audio/wav, audio/flac) y tamaño máximo (100MB). Muestra preview del archivo seleccionado. Al enviar, usa resumable upload para manejar archivos grandes: divide en chunks de 5MB, sube cada chunk con retry automático si falla, muestra progreso granular. Al completar upload, muestra indicador de procesamiento.

**Backend:** Recibe archivo, lo almacena temporalmente. Extrae metadata básica con librería music-metadata: título, artista, álbum, duración, bitrate. Sube archivo original a S3. Dispara función Lambda asíncrona para procesamiento pesado: conversión a formatos optimizados (AAC 128kbps para streaming normal, AAC 256kbps para alta calidad), normalización de volumen a -14 LUFS estándar, generación de waveform como imagen PNG, extracción de portada embebida. Lambda guarda archivos procesados en S3. Al completar, Lambda envía evento a backend. Backend actualiza documento en MongoDB con URLs de todos los assets. Notifica a admin en panel web mediante WebSocket que procesamiento completó.

---

## 9. Flujos de Usuario Completos

### 9.1 Registro y Primer Uso

Un terapeuta descubre la aplicación en App Store. Lee descripción destacando biblioteca especializada de música terapéutica. Ve que incluye trial de 14 días gratuito. Descarga e instala. Al abrir, ve splash screen con logo y tagline. Pantalla de bienvenida explica beneficios: acceso a música curada por profesionales, organizada por tipo de terapia, disponible siempre que necesite. Botones de Registrarse e Ingresar. Toca Registrarse.

Formulario solicita: email profesional, contraseña segura (con indicador de fortaleza), confirmación de contraseña, nombre completo, profesión (dropdown: psicólogo, musicoterapeuta, fisioterapeuta, consejero, otro), país. Checkbox aceptando términos de servicio y política de privacidad con enlaces. Toca Crear Cuenta. Backend valida, crea usuario con trial de 14 días, envía email de bienvenida.

App muestra mensaje de confirmación: "¡Bienvenido! Tienes 14 días de acceso completo gratis. Explora la biblioteca y descubre cómo puede mejorar tus sesiones." Navega al home.

Home muestra banner: "Trial activo - 14 días restantes". Sección "Comienza Aquí" con playlists recomendadas: "Inicio de Sesión - Música para Establecer Ambiente Terapéutico", "Relajación Profunda", "Procesamiento Emocional". Explora y toca primera playlist. Ve lista de 12 canciones con títulos descriptivos, duraciones, iconos de categorías. Toca primera canción "Amanecer Tranquilo". Pantalla de reproductor aparece con animación suave. Muestra portada grande, título, artista, waveform animado sincronizado. Controles grandes de play/pausa, anterior, siguiente. Barra de progreso. Audio comienza tras breve bufferizado. Terapeuta escucha, aprecia calidad y apropiado timing. Toca botón de corazón para añadir a favoritos. Mensaje toast confirma: "Añadido a favoritos". Continúa navegando biblioteca mientras música reproduce en background.

### 9.2 Búsqueda y Descubrimiento

Una terapeuta necesita música específica para sesión de procesamiento de trauma. Abre app, toca tab de Búsqueda. Campo de búsqueda prominente dice "Buscar música terapéutica...". Debajo, chips de búsquedas populares: "Ansiedad", "Duelo", "EMDR", "Mindfulness". Toca "EMDR". Resultados muestran playlist curada "EMDR - Bilateral Stimulation" con 20 canciones diseñadas para técnica Eye Movement Desensitization and Reprocessing. Ve descripción: "Composiciones con patrones sonoros alternantes que apoyan el procesamiento bilateral durante EMDR. Tempo 60-80 BPM." Perfecta para su necesidad. Toca reproducir playlist completa. Primera canción inicia. Swipea hacia abajo para minimizar reproductor y continuar navegando mientras escucha.

Regresa a búsqueda y escribe "ansiedad reducción". Sugerencias de autocompletado aparecen: "ansiedad reducción generalizada", "ansiedad social música". Selecciona primera sugerencia. Resultados muestran múltiples canciones individuales, dos playlists, y un álbum. Filtra por "Solo canciones". Ve "Respiración Consciente en La Mayor" con descripción: "Pieza instrumental con ritmo respiratorio natural para ejercicios de grounding". Toca ícono de información para ver detalle completo. Modal muestra: duración 8:42, categorías (Ansiedad, Mindfulness, Respiración), tempo 56 BPM, instrumento principal (piano), tonalidad La Mayor. Descripción extensa del uso terapéutico. Botones de "Reproducir", "Añadir a Playlist", "Favorito". Toca "Añadir a Playlist". Modal muestra sus playlists personales: "Mis Sesiones Grupales", "Cierre de Sesiones", opción de "Crear Nueva Playlist". Toca "Crear Nueva Playlist". Ingresa nombre: "Trabajo con Ansiedad". Confirma. Canción se añade. Toast confirma.

### 9.3 Durante Sesión Terapéutica

Un musicoterapeuta tiene sesión grupal en 5 minutos. Revisa su playlist "Sesiones Grupales - Energización" previamente creada. Contiene 15 canciones de 4-6 minutos cada una, total 75 minutos cubriendo duración típica de sesión. Conecta su teléfono a parlante Bluetooth del consultorio. Inicia reproducción de playlist. Primera canción "Ritmos de Movimiento" comienza. Atmósfera apropiada se establece. Pacientes comienzan a llegar.

Durante la sesión, utiliza app desde su reloj Apple Watch con controles sincronizados. Puede pausar, saltar, o ajustar volumen sin tocar teléfono, manteniendo atención en pacientes. A mitad de sesión, percibe que grupo necesita transición a estado más calmado. Toma teléfono, swipea hacia arriba para abrir cola de reproducción. Ve siguientes canciones programadas. Decide saltar dos canciones hacia "Transición Suave" que tiene características más calmadas. Toca para saltar. Transición ocurre suavemente entre canciones. Sesión continúa fluidamente.

Al finalizar sesión después de 70 minutos, pausa reproducción. Revisa historial de reproducción para recordar qué canciones resonaron particularmente con el grupo. Ve que reprodujo 13 canciones. Añade tres de ellas que notó impacto positivo a nueva playlist "Favoritas Sesiones Grupales". Durante descanso entre pacientes, explora álbum nuevo que apareció en notificación: "Nuevo: Composiciones Somáticas para Trauma". Lo marca para escuchar completo posteriormente.

### 9.4 Gestión de Suscripción

Una terapeuta recibe notificación: "Tu trial termina en 3 días". Toca notificación, navega a pantalla de suscripción. Ve dos planes: Mensual $19.99/mes, y Anual $199.99/año (equivale a $16.66/mes, ahorro 17%). Cada plan lista features: acceso ilimitado a toda biblioteca, nuevas composiciones mensuales, calidad de audio premium, sin anuncios, cancela cuando quieras. Compara y decide plan anual por mejor valor. Toca "Suscribirse Anual".

Pantalla de pago con integración de Stripe aparece. Muestra resumen: Plan Anual $199.99, facturado hoy, próxima facturación en un año. Formulario Stripe embedded pide información de tarjeta de forma segura (PCI compliant). Ingresa número de tarjeta, fecha expiración, CVV. Información de facturación (nombre, dirección) se pre-llena desde perfil. Revisa y confirma. Toca "Confirmar Pago". Procesamiento ocurre con indicador de carga. Éxito: "¡Suscripción Activada! Gracias por unirte." Email de confirmación se envía con recibo en PDF adjunto. Banner de trial desaparece. App ahora muestra "Plan Anual Activo - Renueva Nov 2026".

Seis meses después, terapeuta considera cambiar a plan mensual por razones presupuestarias. Navega a Perfil > Suscripción. Ve detalle de plan actual, próxima fecha de renovación, método de pago. Botón "Cambiar Plan". Toca. Ve opciones: Cambiar a Mensual (se aplicará al fin del periodo actual, no hay reembolso prorrateado), Cancelar Suscripción. Selecciona cambiar a mensual. Confirmación explica: "Cambiarás a plan mensual ($19.99/mes) el 11 Nov 2026 cuando expire tu periodo anual actual. Continuarás disfrutando acceso completo hasta entonces." Confirma. Cambio programado.

### 9.5 Admin Subiendo Nuevo Contenido

Un administrador recibió nueva colección de 20 composiciones para musicoterapia pediátrica desde un compositor colaborador. Abre panel administrativo web en su computadora. Login con credenciales de admin y código 2FA de app authenticator. Dashboard principal se carga. Navega a Contenido > Canciones. Toca botón "Subir Nueva Canción".

Página de upload se abre. Drag-and-drop zone invita a arrastrar archivos. Arrastra primer archivo WAV de 45MB. Upload inicia mostrando progreso. Mientras sube, llena formulario de metadata: Título "Viaje del Pequeño Explorador", Artista "Elena Compositora", Álbum "Aventuras Terapéuticas Infantiles", Duración se detecta automáticamente (5:23). Selecciona categorías múltiples: Terapia Infantil, Imaginación, Activación Cognitiva. Añade tags: "juego", "exploración", "curiosidad", "5-10 años". Sube portada personalizada del álbum (imagen colorida con dibujo de niño explorando). Área de notas administrativas: "Uso recomendado para terapia de juego, fomentar narrativa imaginativa."

Upload completa. Toca "Guardar y Procesar". Backend recibe información, inicia procesamiento con Lambda. Indicador muestra: "Procesando audio... esto puede tomar 2-3 minutos". Admin continúa subiendo segunda canción mientras primera procesa. Tras 2 minutos, notificación en interfaz: "Viaje del Pequeño Explorador procesado exitosamente". La canción ahora aparece en tabla con estado "Activo".

Admin procede a subir las 19 canciones restantes en secuencia. Tras completar todas, navega a Contenido > Álbumes > Crear Álbum. Ingresa: Título "Aventuras Terapéuticas Infantiles", Descripción extensa sobre uso del álbum, selecciona las 20 canciones recién subidas desde selector múltiple, ordena arrastrando y soltando en secuencia deseada, sube portada del álbum. Guarda. Álbum se crea.

Finalmente, crea playlist curada destacada: Contenido > Playlists > Crear Playlist Curada. Título "Nueva Música para Terapia Infantil", descripción promocional, selecciona 10 mejores canciones del nuevo álbum más 5 de catálogo existente que complementan. Marca "Destacar en Home". Guarda. La playlist aparecerá en home de todos los usuarios en próxima sincronización.

Admin envía notificación push a todos usuarios: Notificaciones > Enviar Nueva. Audiencia: Todos. Título: "Nuevo Álbum Disponible", Mensaje: "Descubre 'Aventuras Terapéuticas Infantiles' - 20 composiciones para sesiones con niños. Escucha ahora." Canales: Push y Email. Enviar Ahora. Confirmación: "Notificación enviada a 1,247 usuarios activos."

---

## 10. Consideraciones de Seguridad

### 10.1 Protección de Contenido (DRM)

Aunque URLs firmadas temporales proveen protección básica, para máxima seguridad considerar:

**HLS Encryption:** Convertir archivos a formato HLS (HTTP Live Streaming) con segmentos encriptados con AES-128. Cada segmento se encripta con clave única. App necesita solicitar clave de desencriptación desde servidor con cada segmento, permitiendo validar suscripción continuamente.

**Forensic Watermarking:** Insertar marcas de agua inaudibles únicas por usuario en el stream. Si audio se graba ilegalmente y distribuye, puede rastrearse a usuario origen.

**Playback Verification:** App envía heartbeats al servidor cada 30 segundos durante reproducción, permitiendo detectar streams anormalmente largos o simultáneos desde misma cuenta.

### 10.2 Prevención de Fraude en Pagos

**Stripe Radar:** Activar Stripe Radar para detección automática de fraude usando machine learning. Bloquea transacciones sospechosas antes de completarse.

**3D Secure:** Habilitar Strong Customer Authentication (SCA) requerido en Europa. Añade capa de autenticación adicional en pagos.

**Límites de Tarjetas Rechazadas:** Después de 3 intentos fallidos de cobro, suspender suscripción y requerir actualización de método de pago.

### 10.3 Seguridad de Datos Personales

**Cifrado en Reposo:** MongoDB Atlas cifra todos los datos en disco con encriptación AES-256.

**Cifrado en Tránsito:** Toda comunicación mediante HTTPS con TLS 1.3. APIs no aceptan HTTP.

**Minimización de Datos:** Recolectar únicamente información necesaria. No solicitar número de teléfono o dirección física salvo sean requeridos.

**Retención Limitada:** Datos de usuarios inactivos >2 años se eliminan automáticamente tras notificación.

**Derecho al Olvido:** Implementar endpoint para solicitar eliminación completa de cuenta y datos asociados, cumpliendo GDPR.

### 10.4 Seguridad del Panel Admin

**Autenticación de Dos Factores:** Obligatorio para todos los admins mediante TOTP (Google Authenticator, Authy).

**Restricción de IP:** Opcionalmente restringir acceso al panel solo desde IPs de oficina corporativa.

**Sesiones Cortas:** Tokens de admin expiran en 15 minutos de inactividad, requiriendo re-autenticación.

**Logging Exhaustivo:** Todos los cambios administrativos se registran en audit_logs con timestamp, admin, acción, detalles, IP.

---

## 11. Implementación de Pagos con Stripe

### 11.1 Flujo Completo de Suscripción

**Setup en Stripe Dashboard:** Crear productos (Plan Mensual, Plan Anual) con precios recurrentes. Configurar webhooks apuntando a https://api.tudominio.com/api/v1/webhooks/stripe.

**Desde Flutter App:**

1. Usuario selecciona plan en pantalla de suscripción
2. App presenta formulario de pago usando stripe_flutter
3. Formulario recolecta información de tarjeta de forma segura (Stripe maneja, nunca llega a tu servidor)
4. Al enviar, Stripe.js tokeniza la tarjeta y retorna PaymentMethod ID
5. App envía PaymentMethod ID y Plan ID a tu backend

**En Backend:**

6. Backend recibe request con PaymentMethod ID
7. Verifica usuario no tenga suscripción activa
8. Crea o recupera Customer en Stripe asociado al usuario
9. Adjunta PaymentMethod al Customer
10. Crea Subscription en Stripe con el Customer y Price ID del plan
11. Stripe intenta cobrar inmediatamente
12. Si pago exitoso, Subscription se activa
13. Webhook invoice.payment_succeeded se dispara
14. Backend maneja webhook, actualiza usuario localmente con datos de suscripción
15. Backend retorna éxito a app
16. App navega a pantalla de confirmación

**Renovaciones Automáticas:** Stripe intentará cobrar automáticamente al llegar fecha de renovación. Webhook invoice.payment_succeeded confirma éxito. Webhook invoice.payment_failed alerta de fallo, dando varios días antes de cancelar.

### 11.2 Gestión de Fallos de Pago

Stripe reintenta cobros fallidos automáticamente según configuración (típicamente 4 intentos en 3 semanas). Al fallar primer intento:

1. Webhook invoice.payment_failed se dispara
2. Backend actualiza estado de suscripción a past_due
3. Backend envía email a usuario: "Problema con tu pago"
4. App muestra banner en home: "Actualiza tu método de pago para mantener acceso"
5. Usuario actualiza tarjeta en app
6. Stripe reintenta cobro exitosamente
7. Webhook invoice.payment_succeeded confirma
8. Estado vuelve a active

Si todos los intentos fallan, webhook customer.subscription.deleted se dispara, backend marca suscripción cancelada, usuario pierde acceso.

### 11.3 Cambios de Plan

**Upgrade (de Mensual a Anual):** Stripe prorratea automáticamente. Usuario paga diferencia prorrateada inmediatamente. Próxima facturación será en un año.

**Downgrade (de Anual a Mensual):** Por simplicidad, el cambio se aplica al fin del periodo actual. Usuario continúa con plan anual hasta expiración, luego cambia a mensual. No hay reembolso prorrateado.

Implementación: Backend llama Stripe API para modificar suscripción con proration_behavior apropiado.

---

## 12. Testing y Calidad

### 12.1 Testing de Flutter

**Unit Tests:** Lógica de repositorios, parseo de modelos, funciones de utilities. Coverage mínimo 70% de código crítico.

**Widget Tests:** Pantallas individuales con datos mockeados, verificar renderizado correcto, simular interacciones.

**Integration Tests:** Flujos completos (login, búsqueda, reproducción) en emulador con backend de testing.

**Golden Tests:** Screenshots de pantallas clave para detectar regresiones visuales.

### 12.2 Testing de Backend

**Unit Tests:** Funciones de servicios, validadores, helpers con Jest.

**Integration Tests:** Endpoints completos con Supertest contra MongoDB de testing y mocks de Stripe.

**Load Testing:** k6 o Artillery simulan carga de 1000 usuarios concurrentes reproduciendo música para validar capacidad de streaming.

### 12.3 Testing de Streaming

**Verificación de URLs Firmadas:** Test automatizado valida que URL firmada funciona correctamente, expira tras timeout, y se rechaza si firma es inválida.

**Test de Concurrencia:** Validar que límite de streams simultáneos por usuario funciona (debe rechazar segundo stream desde diferente dispositivo).

**Test de Latencia:** Medir tiempo desde request de URL hasta inicio de reproducción en diferentes regiones geográficas.

### 12.4 Testing de Pagos

**Modo Test de Stripe:** Usar tarjetas de prueba de Stripe para simular: pagos exitosos, pagos rechazados, tarjetas que requieren 3D Secure, tarjetas con fondos insuficientes.

**Test de Webhooks:** Simular eventos de Stripe localmente para validar manejo correcto.

**Test de Renovación:** Configurar suscripción de prueba con ciclo de 1 minuto para observar renovación automática.

---

## 13. Deployment y DevOps

### 13.1 Backend

**Containerización:** Dockerfile optimizado multi-stage: stage 1 compila TypeScript, stage 2 crea imagen productiva solo con archivos necesarios.

**Orquestación:** Deploy en DigitalOcean App Platform, AWS ECS, o Kubernetes. Mínimo 2 instancias para alta disponibilidad.

**Variables de Entorno:** Secrets almacenados en AWS Secrets Manager o similar, nunca en código.

**Health Checks:** Endpoint /health retorna status 200 si API está operativa y puede conectarse a MongoDB.

### 13.2 Flutter App

**Build Android:** `flutter build apk --release` genera APK. `flutter build appbundle` genera AAB para Play Store. Firma con clave de producción. Sube a Google Play Console con release notes.

**Build iOS:** `flutter build ios --release` en Xcode genera archivo. Sube a App Store Connect con Xcode o Fastlane. Pasa revisión de Apple.

**Versionado:** Incrementar version en pubspec.yaml: MAJOR.MINOR.PATCH+BUILD. Sincronizar con tags de Git.

### 13.3 Panel Admin Web

**Build:** `npm run build` genera optimizado con Next.js. Deploy en Vercel (ideal para Next.js) o hosting estático con CDN.

**Environment Variables:** Separar configuración de desarrollo, staging, producción.

### 13.4 CI/CD Pipeline

GitHub Actions automatiza:
1. Lint y format check
2. Run tests
3. Build aplicaciones
4. Scan de vulnerabilidades (Snyk)
5. Deploy automático a staging en merge a `develop`
6. Deploy manual a producción en release tag

### 13.5 Monitoreo

**Uptime Monitoring:** Pingdom o UptimeRobot verifican disponibilidad cada minuto.

**APM:** Datadog o New Relic rastrean latencia de endpoints, queries lentas a MongoDB, usage de CPU/RAM.

**Error Tracking:** Sentry captura excepciones con stack traces completos.

**Logs Centralizados:** CloudWatch Logs, Papertrail, o Loggly agregan logs de todas las instancias.

**Alertas:** PagerDuty notifica equipo on-call si latencia >1s, error rate >1%, uptime <99%.

---

## 14. Estimación de Recursos

### 14.1 Equipo Mínimo

- Desarrollador Flutter Senior (3+ años exp): App móvil completa
- Desarrollador Backend Senior (Node.js): APIs, integración Stripe, procesamiento audio
- Desarrollador Frontend (React): Panel administrativo
- Diseñador UI/UX: Interfaces, flujos, branding
- QA Tester: Testing manual y automatizado
- DevOps/SRE (part-time): Infraestructura, CI/CD, monitoreo

### 14.2 Cronograma MVP (20 semanas)

**Fase 1 - Planificación (2 semanas):** Refinamiento de requerimientos, diseño de wireframes y mockups, arquitectura detallada, setup de entornos.

**Fase 2 - Backend Core (4 semanas):** Autenticación, gestión de usuarios, integración Stripe suscripciones, APIs de catálogo musical, APIs de reproducción.

**Fase 3 - Infraestructura de Audio (3 semanas):** Configuración S3 y CDN, sistema de URLs firmadas, pipeline de procesamiento de audio con Lambda, testing de streaming.

**Fase 4 - Flutter App (6 semanas):** Autenticación y onboarding, home y navegación, reproductor de audio con just_audio, búsqueda y biblioteca, gestión de suscripciones con Stripe, favoritos y playlists.

**Fase 5 - Panel Admin (4 semanas):** Autenticación admin, dashboard analytics, gestión de usuarios y suscripciones, upload y gestión de contenido, sistema de notificaciones.

**Fase 6 - Integración y Testing (3 semanas):** Testing E2E de todos los flujos, testing de carga de streaming, testing de integración de pagos, corrección de bugs, optimización de performance.

**Fase 7 - Beta y Ajustes (2 semanas):** Beta con usuarios reales (20-30 terapeutas), recolección de feedback, ajustes finales, preparación de materiales de lanzamiento.

**Fase 8 - Lanzamiento (1 semana):** Deploy a producción, envío a stores, activación de marketing, monitoreo intensivo post-lanzamiento.

### 14.3 Costos Estimados

**Desarrollo (5 meses):**
- Flutter Developer Senior: $6000/mes × 5 = $30,000
- Backend Developer Senior: $6000/mes × 5 = $30,000
- Frontend Developer: $5000/mes × 3 = $15,000
- UI/UX Designer: $4000/mes × 2.5 = $10,000
- QA Tester: $3500/mes × 3 = $10,500
- DevOps Engineer (part-time): $3000/mes × 2 = $6,000

**Subtotal Desarrollo: $101,500**

**Infraestructura (mensual):**
- MongoDB Atlas (M10 Cluster): $60
- AWS/DigitalOcean (backend, 2 instancias): $100
- S3 Storage (500GB audio): $12
- CloudFront CDN (1TB transfer): $85
- Lambda (procesamiento): $20
- Redis: $30
- Stripe (transacciones 2.9% + $0.30)
- Sentry: $26
- SendGrid: $20
- Servicios varios: $50

**Subtotal Infraestructura: $403/mes + fees de Stripe**

**Otros:**
- Cuentas desarrollador (Google $25 + Apple $99): $124 one-time
- Dominio y SSL: $50/año
- Legal (términos, privacidad): $1,500
- Contenido musical inicial (licencias o composiciones): $5,000-15,000
- Marketing y lanzamiento: $5,000

**Total Estimado MVP: $115,000-125,000**

### 14.4 Proyección de Ingresos

**Supuestos conservadores:**
- Precio mensual: $19.99
- Precio anual: $199.99
- Ratio anual/mensual: 40/60
- Churn mensual: 5%
- Crecimiento: 50 usuarios nuevos/mes

**Mes 12:**
- Usuarios activos: ~400
- MRR: ~$6,000
- Costos operativos: ~$1,500/mes
- Margen: ~$4,500/mes

**Break-even:** Mes 15-18 aproximadamente.

**Escalamiento:** Al llegar a 1000 usuarios, ingresos ~$15,000/mes cubren ampliamente costos operativos (~$3,000) y permiten reinversión en desarrollo.

---

## 15. Estrategia de Lanzamiento y Crecimiento

### 15.1 Pre-Lanzamiento

**Beta Cerrada:** Invitar 30-50 terapeutas early adopters para testing. Ofrecer suscripción gratis de por vida a cambio de feedback. Iterar basándose en feedback.

**Contenido Inicial:** Lanzar con biblioteca base de 200-300 composiciones cubriendo categorías principales. Calidad sobre cantidad.

**Verificación de Profesionales:** Implementar proceso sencillo pero efectivo para verificar que usuarios son profesionales legítimos, previniendo abuso.

### 15.2 Canales de Adquisición

**Orgánico/SEO:** Blog con contenido educativo sobre uso terapéutico de música. Optimizar para keywords relevantes.

**Redes Sociales:** LinkedIn para alcanzar profesionales, Instagram con contenido visual sobre terapia musical.

**Asociaciones Profesionales:** Contactar asociaciones de psicología, musicoterapia, consejería. Ofrecer membresías grupales con descuento.

**Webinars:** Organizar webinars gratuitos sobre técnicas de musicoterapia, mostrando cómo la plataforma facilita aplicación.

**Programa de Referidos:** Usuarios actuales invitan colegas, ambos reciben mes gratis.

### 15.3 Retención

**Onboarding Guiado:** Tutorial interactivo al primer uso mostrando features clave.

**Contenido Nuevo Regular:** Añadir 20-30 composiciones nuevas mensualmente, notificar usuarios.

**Comunicación:** Newsletter mensual con tips de uso, spotlight de compositores, estudios de caso.

**Comunidad:** Foro o grupo privado donde terapeutas comparten experiencias de uso de música en sesiones.

**Flexibilidad:** Permitir pausar suscripción (vacation mode) en vez de cancelar, reteniendo usuario.

### 15.4 Expansión Futura

**Playlists Personalizadas con IA:** Algoritmo recomienda música basándose en historial de uso y preferencias.

**Integración con Calendarios:** Sugerir música apropiada según tipo de sesión agendada.

**Versión para Consultorios:** Plan premium con múltiples usuarios del mismo consultorio, gestión centralizada.

**Marketplace de Compositores:** Permitir compositores especializados vender sus obras en plataforma, tomando comisión.

**Expansión Geográfica:** Traducir a múltiples idiomas, adaptar contenido a prácticas terapéuticas regionales.

---

## 16. Consideraciones Legales

### 16.1 Derechos de Autor Musical

**Licenciamiento:** Asegurar que toda la música en la plataforma tiene licencias apropiadas. Opciones: crear contenido original contratando compositores con cesión completa de derechos, licenciar música de bibliotecas royalty-free especializadas, establecer acuerdos con compositores independientes con regalías por stream.

**Registro de Obras:** Documentar claramente titularidad y licencias de cada composición.

**Protección contra Piratería:** Términos de servicio prohíben explícitamente grabación, descarga, o redistribución. Implementar DMCA takedown policy para responder a reclamos.

### 16.2 Términos de Servicio

Establecer claramente: usos permitidos (sesiones terapéuticas profesionales), usos prohibidos (redistribución, descarga, uso público no terapéutico), política de suscripciones (renovación automática, cancelación, reembolsos), limitación de responsabilidad, jurisdicción aplicable.

### 16.3 Privacidad

Política de privacidad clara explicando: datos recolectados (email, profesión, historial de reproducción), uso (personalización, analytics, facturación), no venta a terceros, derechos del usuario (acceso, corrección, eliminación).

### 16.4 Compliance

**PCI-DSS:** Delegado completamente a Stripe, no manejar datos de tarjetas directamente.

**GDPR:** Si hay usuarios en Europa, cumplir requisitos: consentimiento explícito, derecho al olvido, portabilidad de datos, notificación de brechas en 72 horas.

**HIPAA:** Si se almacena información de pacientes (NO recomendado), requerirá compliance HIPAA complejo. Mejor evitar almacenar cualquier dato de pacientes.

---

## 17. Recomendaciones Finales

### 17.1 Priorización para MVP

Enfocarse en funcionalidad core: streaming confiable, suscripciones automatizadas, catálogo bien organizado, panel admin funcional. Posponer features avanzadas: recomendaciones con IA, integración con calendarios, modo offline, para versiones posteriores.

### 17.2 Calidad de Audio

Invertir en composiciones de alta calidad profesional. Música de baja calidad destruirá percepción de valor. Considerar contratar compositores experimentados en música terapéutica.

### 17.3 Validación del Modelo

Antes de desarrollo completo, validar interés del mercado: landing page con signup para early access, encuestas a terapeutas sobre pricing y features, conversaciones con 20-30 profesionales para entender necesidades profundamente.

### 17.4 Protección de Contenido

Balancear protección con experiencia de usuario. Medidas excesivas (DRM muy restrictivo) frustran usuarios legítimos más que prevenir piratería. URLs firmadas temporales + detección de uso anómalo suele ser suficiente.

### 17.5 Métricas Clave a Monitorear

- Tasa de conversión trial → pago
- Churn rate mensual
- MRR y crecimiento
- Tiempo promedio de uso por sesión
- Canciones más reproducidas
- Net Promoter Score (NPS)

---

## Conclusión

Este informe técnico proporciona especificaciones completas para desarrollar una plataforma profesional de streaming de música terapéutica con modelo de suscripción. La arquitectura descrita utilizando Flutter, Node.js, MongoDB, y servicios cloud escalables permitirá crear MVP robusto en aproximadamente 5 meses con equipo de 4-6 personas. El enfoque en protección de contenido mediante streaming seguro, integración sólida de pagos recurrentes con Stripe, y experiencia de usuario optimizada para profesionales terapéuticos posiciona el producto para éxito en nicho especializado con necesidades claras. La escalabilidad inherente del stack tecnológico y modelo de negocio recurrente facilitan crecimiento sostenible conforme se valida product-market fit y se expande biblioteca de contenido.