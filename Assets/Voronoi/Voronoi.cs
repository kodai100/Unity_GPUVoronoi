using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Voronoi : MonoBehaviour {

    public Material material;
    public int num;
    public float width;

    void Start () {
        CreateMesh();
    }

    void CreateMesh() {
        var mesh = new Mesh();
        mesh.vertices = MakeRandomPointsInSquare(num, width);
        mesh.uv = MakeColorIndex(num);

        var filter = GetComponent<MeshFilter>();
        filter.sharedMesh = mesh;
        filter.mesh.SetIndices(MakeSequencialIndices(num), MeshTopology.Points, 0);

        var renderer = GetComponent<MeshRenderer>();
        renderer.material = material;
    }

    void Update() {

    }

    void OnRenderObject() {
        // Graphics.DrawProcedural(MeshTopology.Points, num);
    }

    Vector3[] MakeRandomPointsInSquare(int n, float width) {
        Vector3[] points = new Vector3[n];
        for (int i = 0; i < points.Length; i++) {
            points[i] = new Vector3(Random.Range(-width / 2, width / 2), Random.Range(-width / 2, width / 2), 0f);
        }
        return points;
    }

    Vector2[] MakeColorIndex(int n) {
        Vector2[] uvs = new Vector2[n];
        for (int i = 0; i < uvs.Length; i++) {
            uvs[i] = new Vector2((float)i/uvs.Length, 1);
        }
        return uvs;
    }
	
    int[] MakeSequencialIndices(int n) {
        int[] indices = new int[n];
        for (int i = 0; i < indices.Length; i++) {
            indices[i] = i;
        }
        return indices;
    }
    
}
