#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define TRUE 1
#define FALSE 0
// constantes
#define TRUCK_TAX 25
#define CAR_TAX 10
#define BIKE_TAX 6

typedef struct _client_{
    int id, arrival, departure;
    int fee;
    char plate[20];
    char vehicle[20];
}Client;

typedef struct _parking_slots{
    int size;
    int free;
    struct _client_ **clients;
}Park;

Park* park = NULL;

void create_empty_park(int size)
{
    park = (Park*)malloc(sizeof(Park));
    park->clients = (Client**)malloc(sizeof(Client*)*size);
    for(int i=0;i<size;i++){
        park->clients[i] = NULL;
    }
    park->size = size;
    park->free = size;
}

void destroy_park()
{
    int i;
    for(i=0;i<park->size;i++){
        if(park->clients[i]!=NULL) free(park->clients[i]);
    }
    free(park->clients);
    free(park);
}
// não implementada
float get_time()
{
    return -1.0;
}

int hash_function(int id)
{
    float aux = (park->size) * (((float)id * 0.5));
    unsigned int hash = floor(aux);
    return hash % park->size;
}

int get_id(char plate[20])
{
    int temp = atoi(plate);
    unsigned int id = hash_function(temp);
    int k = 1;
    while((strcmp(park->clients[id]->plate,plate) != 0) && (park->clients[id] != NULL)){
        id = (id + k*k) % park->size;
        k++;
    }
    if(strcmp(park->clients[id]->plate,plate) == 0){
        return id;
    }
    else{
        return -1;
    }
}

int generate_id(char plate[20])
{
    int temp = atoi(plate);
    unsigned int id = hash_function(temp);
    int k = 1;
    while(park->clients[id]!=NULL && strcmp(park->clients[id]->plate,plate) != 0){
        id = (id + k*k) % park->size;
        k++;
    }
    if(park->clients[id] ==NULL)
        return id;
    else
        return -1;
}

int check_spots()
{
    if(park->free == 0) return FALSE;
    else return TRUE;
}

Client* fill_new_client(Client* client)
{
    client = (Client*)malloc(sizeof(Client));
    printf("\nPlate?: ");
    scanf("%s",client->plate);
    printf("\nVehicle?: ");
    scanf("%s",client->vehicle);
    client->id = generate_id(client->plate);
    client->arrival = get_time();
    client->departure = -1;
    client->fee = 0;
    if(client->id != -1){
        return client;
    }
    free(client);
    return NULL;
}

int register_new_client()
{
    Client *temp = NULL;
    if(check_spots()){
        temp = fill_new_client(temp);
        if(temp != NULL){
            park->clients[temp->id] = temp;
            park->free--;
            printf("Car registered.\n");
            return TRUE;
        }

    }
    printf("No spots available or car already registered.\n");
    return FALSE;
}

void compute_fee()
{
    printf("Scope\n\n");
}
// incompleta
void get_ticket(Client* client)
{
    int time_spent;
    client->departure = get_time();
    time_spent = (client->departure) - (client->arrival);
    client->fee = compute_fee();
    printf("SPOT ID   --> %d\n", client->id);
    printf("PLATE     --> %s\n", client->plate);
    printf("VEHICLE   --> %s\n", client->vehicle);
    printf("ARRIVAL   --> %d\n", client->arrival);
    printf("DEPARTURE --> %d\n", client->departure);
    printf("FEE       --> %d\n", client->fee);
}

// incompleta
void checkout()
{
    int temp_id;
    char temp_plate[20];
    Client* temp_client;
    printf("Plate?: ");
    scanf("%s",temp_plate);
    temp_id = get_id(temp_plate);
    if(temp_id != -1){
        temp_client = park->clients[temp_id];
        /*printf("Achou\n%s\n", temp_client->vehicle);*/
        /*get_ticket(temp_client);*/
    }
    else{
        printf("Plate not found\n");
    }
}
// incompleta
void menu()
{
    printf("1 - Register\n");
    printf("2 - Checkout\n");
    printf("3 - Search\n");
}

int main(int argc, char* argv[])
{
    int i;
    create_empty_park(1000);
    for(i=0;i<3;i++){
        register_new_client();
    }
    checkout();
    destroy_park();
}
