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
    float amount;
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
    hash = math.floor((park->size) * ((id * 0.5) % 1));
    return hash;
}

int get_id(char plate[20])
{
    int temp = atoi(plate);
    int id = hash_function(temp);
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
    int id = hash_function(temp);
    int k = 1;
    while(park->clients[id]!=NULL){
        id = (id + k*k) % park->size;
        k++;
    }
    return id;
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
    scanf("%d",client->plate);
    printf("\nVehicle?: ");
    scanf("%s",client->vehicle);
    client->id = generate_id(client->plate);
    client->arrival = get_time();
    client->departure = -1;
    client->amount = 0;
    return client;
}

int register_new_client()
{
    Client *temp = NULL;
    if(check_spots()){
        temp = fill_new_client(temp);
        park->clients[temp->id] = temp;
        park->free--;
        return TRUE;
    }
    else{
        printf("No spots avaible!\n");
        return FALSE;
    }
}

void get_ticket(Client* client)
{
    printf("Scope\n");
}

// incompleta
void checkout()
{
    int temp_plate, temp_id;
    Client* temp_client;
    printf("Plate?: ");
    scanf("%d",&temp_plate);
    temp_id = get_id(temp_plate);
    if(temp_id != -1){
        temp_client = park->clients[temp_id];
        get_ticket(temp_client);
    }
    else{
        printf("Plate not found\n");
    }
}
// incompleta
void menu()
{
    printf("1 - Cadastrar\n");
    printf("2 - Pagar\n");
    printf("3 - Buscar\n");
}

int main(int argc, char* argv[])
{
    create_empty_park(1000);
}
