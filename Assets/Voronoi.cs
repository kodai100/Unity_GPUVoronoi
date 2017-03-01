using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Voronoi : MonoBehaviour {

    public Material material;
    public int num;
    public float radius;

    void Start () {
        var mesh = new Mesh();
        mesh.vertices = MakeRandomPointsInSphere(num, radius);

        var filter = GetComponent<MeshFilter>();
        filter.sharedMesh = mesh;
        filter.mesh.SetIndices(MakeSequencialIndices(num), MeshTopology.Points, 0);

        var renderer = GetComponent<MeshRenderer>();
        renderer.material = material;
    }

    Vector3[] MakeRandomPointsInSphere(int n, float rad) {
        Vector3[] points = new Vector3[n];
        for(int i = 0; i<points.Length; i++) {
            points[i] = rad * Random.insideUnitSphere;
        }
        return points;
    }
	
    int[] MakeSequencialIndices(int n) {
        int[] indices = new int[n];
        for (int i = 0; i < indices.Length; i++) {
            indices[i] = i;
        }
        return indices;
    }

	void Update () {
		
	}

    void OnRenderObject() {
        // Graphics.DrawProcedural(MeshTopology.Points, num);
    }
    
}
