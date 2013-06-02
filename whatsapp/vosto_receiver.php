<?php
    require "whatsprot.class.php";
    # nohup php vosto_receiver.php &

    $fromMobNumber = "27745532622"; //ENTER YOUR GOOGLEVOICENUMBER HERE
    $id = "Jt4WETODRNpyNya6NnCFUSIuxwE=";  //ENTER THE PASSWORD YOU COPIED EARLIER HERE
    $nick = "Vosto";

    $w = new WhatsProt($fromMobNumber, $id, $nick);
    $w->Connect();    
    $w->LoginWithPassword($id);
    // $w->Message($toMobNumber , "Hi this is Vosto");
    // sleep (2);

    $w->PollMessages();
    $msgs = $w->GetMessages();
    foreach ($msgs as $m) {

        # process inbound messages
        if($m->_children[0]->_tag == 'notify'){
            $sender_name = $m->_children[0]->_attributeHash['name'];
            $message = $m->_children[2]->_data;

            $foramtted_message = explode(' ', $message);

                $order_number = $foramtted_message[0];
                $time_to_ready = $foramtted_message[1];
                $store_order_number = $foramtted_message[2];

                # log user in
                $curl = curl_init();

                # build data aray that will be sent to api
                $data = array(
                    'authentication_token' => 'CXTTTTED2ASDBSD3',
                    'time_to_ready' => $time_to_ready,
                    'store_order_number' => $store_order_number,
                );

                curl_setopt($curl, CURLOPT_URL, "http://107.22.211.58:9000/api/v1/orders/" . $order_number . "/in_progress");
                curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

                curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
                // Send the request & save response to $resp
                $response = curl_exec($curl);

                if (curl_errno($curl)) {
                    echo '<pre>';print_r("Order ID:  Error not updated to in progress");
                    print curl_error($curl);
                } else {
                    # do new order request
                    $decoded_json = json_decode($response);
                    echo '<pre>';print_r("Order ID: ".$order_number." updated to in progress");
                    # echo '<pre>';print_r(processCurlJsonrequest('http://107.22.211.58:9000/api/v1/orders',));exit;
                }
               
                // Close request to clear up some resources
                curl_close($curl);
        }

    }

    exit;

function processCurlJsonrequest($URL, $data) { //Initiate cURL request and send back the result
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
    curl_setopt($ch, CURLOPT_URL, $URL);
    curl_setopt($ch, CURLOPT_USERAGENT, $this->_agent);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_COOKIEFILE, $this->_cookie_file_path);
    curl_setopt($ch, CURLOPT_COOKIEJAR, $this->_cookie_file_path);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, TRUE);
    curl_setopt($ch, CURLOPT_VERBOSE, TRUE);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    curl_setopt($ch, CURLOPT_POST, 1); 
    $resulta = curl_exec($ch);
    if (curl_errno($ch)) {
        print curl_error($ch);
    } else {
        curl_close($ch);
    }
    return $resulta;
}
?>
