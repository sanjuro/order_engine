<?php
    #  php vosto_sender.php 27833908314 "New VOSTO ORDER 1705 - Customer: Shadley Wentzel, 0833908314 Order Number: 1705 Item: 4 X Vosto Burger, Options:  Special Instructions: test,"
    #  php vosto_sender.php "27793901927" "Test"
    require "whatsprot.class.php";

    $fromMobNumber = "27745532622"; //ENTER YOUR GOOGLEVOICENUMBER HERE
    # $fromMobNumber = "27833908314"; //ENTER YOUR OWN NUMBER HERE
    $destinationPhone = $argv[1];
    $message = $argv[2];

    $id = "Jt4WETODRNpyNya6NnCFUSIuxwE=";  //ENTER THE PASSWORD YOU COPIED EARLIER HERE
    $nick = "Vosto";

    $w = new WhatsProt($fromMobNumber, $id, $nick);
    $w->Connect();    
    $w->LoginWithPassword($id);

    /**
     * Send a text message to the user/group.
     *
     * @param $destinationPhone string The reciepient to send.
     * @param $message string The text message.
     */
     $w->Message($destinationPhone, $message);

    /**
     * Wait for message delivery notification.
     */
     $w->WaitforReceipt();

    exit;
?>