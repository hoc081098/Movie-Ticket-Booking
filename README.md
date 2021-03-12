# Movie-Ticket-Booking

A movie tickets booking and management application using `Flutter` and `NestJS`.

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/b231badd3e184bf1b1cac6df7e21a374)](https://app.codacy.com/gh/hoc081098/Movie-Ticket-Booking?utm_source=github.com&utm_medium=referral&utm_content=hoc081098/Movie-Ticket-Booking&utm_campaign=Badge_Grade_Settings)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fhoc081098%2FMovie-Ticket-Booking&count_bg=%23A16CF7&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=true)](https://hits.seeyoufarm.com)

## Features

-   Flutter BLoC pattern and [RxDart](https://pub.dev/packages/rxdart), [rx_redux](https://pub.dev/packages/rx_redux), [stream_loader](https://pub.dev/packages/stream_loader) for state management.
-   Firebase authentication, socket.io.
-   Backend using NestJS, MongoDB database and Neo4j.
-   Recommendation using Neo4j database and Collaborative filtering via Cypher query.

## Directory structure
```
project
│   README.md
│
└───Backend
│   └───main                   <- [Backend]
│       │   ...
│       │   ...
│   
└───Docs
│   │   Database.zip
│   │   Diagram.png
│   │   diagram_sql.png
│
└───MobileApp
│   └───datn                   <- [User mobile app]
│   │   │   ...
│   │   │   ...
│   │
│   └───movie_admin            <- [Admin, staff mobile app]
│       │   ...
│       │   ...
│
└───Screenshots
    │   Screenshot_add_card.png
    │   Screenshot_add_comment.png
    │   ...
```

## Setup and run

<details>
    <summary>Click to expand</summary>
    <br>

-   Download APK
    -   [User APK](https://github.com/hoc081098/DATN/blob/master/MobileApp/datn/build/app/outputs/flutter-apk/app-release.apk)
    -   [Admin APK](https://github.com/hoc081098/DATN/blob/master/MobileApp/movie_admin/build/app/outputs/flutter-apk/app-release.apk)
    
-   Setup and run
    -   Backend (**You can use my url: https://datn-081098.herokuapp.com/**)
        -	Install [Node.js](https://nodejs.org/en/download/), [NestJS](https://docs.nestjs.com/)
        -	Install [MongoDB](https://docs.mongodb.com/manual/installation/), [Neo4j](https://neo4j.com/docs/operations-manual/current/installation/windows/)
        -	Create [Stripe secret API key](https://stripe.com/docs/keys), Create [MovieDb api key](https://www.themoviedb.org/settings/api)
        -   Create MongoDB database, (eg. `movieDb`), and create Neo4j database.
        -   Start MongoDB and Neo4j.
        -   Create .env file `./Backend/main/.env` has following structure:
            ```bash
            MONGODB_URL=mongodb://localhost:27017/movieDb
            MOVIE_DB_API_KEY=movie_db_api_key
            STRIPE_SECRET_API=stripe_secret_api_key
            EMAIL=your_email@gmail.com
            EMAIL_PASSWORD=your_email_passwrod
            NEO4J_URL=bolt://localhost:7687
            NEO4J_USER=neo4j
            NEO4J_PASSWORD=password
            ```
        -   Installation dependencies
            ```bash
            $ npm install
            ```
            
        -   Running the Backend app
            ```bash
            # development
            $ npm run start
            
            # watch mode
            $ npm run start:dev
            
            # production mode
            $ npm run start:prod
            ```
        -   Seed data (Put headers in your request `Authorization: Bearer {{token}}`, token can be get from Mobile App after successfully login).
            -   Movies: `POST http://localhost:3000/movies/seed`.
            -   Theatres: `POST http://localhost:3000/theatres/seed`.
            -   Seats: `POST http://localhost:3000/seats/seed`, body: `{"id": theatreId}`.
            -   Show times: `POST http://localhost:3000/show-times/seed`.
            -   Tickets: `POST http://localhost:3000/seats/seed-tickets`.
            -   Transfer data from MongoDB to Neo4j: `POST http://localhost:3000/neo4j/transfer`.
            -   Comments _(optional)_: `POST http://localhost:3000/comments/seed`.
            -   Promotions _(optional)_: `POST http://localhost:3000/promotions/seed`.
            
    -   Flutter
        -   Install [Flutter](https://flutter.dev/docs/get-started/install).
        -   Using **`stable`** channel:
            ```bash
            ❯ flutter channel stable
            ❯ flutter upgrade
            ```
        -   Flutter version:
            ```bash
            ❯ flutter --version
            Flutter 2.0.0 • channel stable • https://github.com/flutter/flutter.git
            Framework • revision 60bd88df91 (8 days ago) • 2021-03-03 09:13:17 -0800
            Engine • revision 40441def69
            Tools • Dart 2.12.0
            ```
        -   Install all the packages by: 
            ```bash
            ❯ flutter packages get
            ```
        -   Create .env file `./MobileApp/datn/.prod.env` and `./MobileApp/movie_admin/.env` has following structure:
            ```bash
            BASE_URL=datn-081098.herokuapp.com
            WS_URL=https://datn-081098.herokuapp.com/
            WS_PATH=/socket
            PLACES_API_KEY=your_places_api_key
            ```
        -   Run app on real devices or emulator by:
            ```bash
            ❯ flutter run
            ```
            
</details>

## Screenshots

### User mobile app

<details>
    <summary>View Screenshots</summary>
    <br>

|  |  |  |
| :---:  | :---:  | :---:  |
| ![](Screenshots/Screenshot_login1.png)            | ![](Screenshots/Screenshot_home0.png)               | ![](Screenshots/Screenshot_home1.png)             
| ![](Screenshots/Screenshot_home2.png)             | ![](Screenshots/Screenshot_home3.png)               | ![](Screenshots/Screenshot_home4.png)             
| ![](Screenshots/Screenshot_home5.png)             | ![](Screenshots/Screenshot_all.png)                 | ![](Screenshots/Screenshot_showtimes0.png) 
| ![](Screenshots/Screenshot_showtimes1.png)        | ![](Screenshots/Screenshot_showtimes2.png)          | ![](Screenshots/Screenshot_showtimes3.png)          
| ![](Screenshots/Screenshot_comments0.png)         | ![](Screenshots/Screenshot_comments1.png)           | ![](Screenshots/Screenshot_add_comment.png) 
| ![](Screenshots/Screenshot_movie_info0.png)       | ![](Screenshots/Screenshot_movie_info1.png)         | ![](Screenshots/Screenshot_movie_info2.png) 
| ![](Screenshots/Screenshot_seats0.png)            | ![](Screenshots/Screenshot_seats1.png)              | ![](Screenshots/Screenshot_combo.png) 
| ![](Screenshots/Screenshot_checkout0.png)         | ![](Screenshots/Screenshot_checkout1.png)           | ![](Screenshots/Screenshot_email.jpg)
| ![](Screenshots/Screenshot_cards.png)             | ![](Screenshots/Screenshot_add_card.png)            | ![](Screenshots/Screenshot_favorites.png)
| ![](Screenshots/Screenshot_notifications.png)     | ![](Screenshots/Screenshot_notificationbar.jpg)     | ![](Screenshots/Screenshot_profile.png)             
| ![](Screenshots/Screenshot_update_profile1.png)   | ![](Screenshots/Screenshot_search.png)              | ![](Screenshots/Screenshot_search_filter.png) 
| ![](Screenshots/Screenshot_search_result.png)     | ![](Screenshots/Screenshot_reservations.png)        | ![](Screenshots/Screenshot_ticket.png) 

</details>  

### Neo4j Graph

<details>
    <summary>View Images</summary>
    <br>

<p align="center">
    <img src="https://github.com/hoc081098/Movie-Ticket-Booking/blob/master/Screenshots/collaborative.png?raw=true" />
    <br>
    <em>Collaborative filtering</em>
</p>

<p align="center">
    <img src="https://github.com/hoc081098/Movie-Ticket-Booking/blob/master/Screenshots/graph-jaccard.png?raw=true" />
    <br>
    <em>Jaccard index (Jaccard similarity coefficient)</em>
</p>


<p align="center">
    <img src="https://github.com/hoc081098/Movie-Ticket-Booking/blob/master/Screenshots/content-based-graph.png?raw=true" />
    <br>
    <em>Weighted content</em>
</p>

</details>

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://www.linkedin.com/in/hoc081098/"><img src="https://avatars.githubusercontent.com/u/36917223?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Petrus Nguyễn Thái Học</b></sub></a><br /><a href="https://github.com/hoc081098/Movie-Ticket-Booking/commits?author=hoc081098" title="Code">💻</a> <a href="https://github.com/hoc081098/Movie-Ticket-Booking/commits?author=hoc081098" title="Documentation">📖</a> <a href="#maintenance-hoc081098" title="Maintenance">🚧</a></td>
    <td align="center"><a href="https://github.com/phong016688"><img src="https://avatars.githubusercontent.com/u/37899092?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Phong</b></sub></a><br /><a href="https://github.com/hoc081098/Movie-Ticket-Booking/commits?author=phong016688" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/gunasekharravilla"><img src="https://avatars.githubusercontent.com/u/53616269?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Gunasekhar Ravilla</b></sub></a><br /><a href="https://github.com/hoc081098/Movie-Ticket-Booking/issues?q=author%3Agunasekharravilla" title="Bug reports">🐛</a> <a href="#ideas-gunasekharravilla" title="Ideas, Planning, & Feedback">🤔</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
